require 'lydown/templates'
require 'lydown/cli/output'
require 'parallel'

module Lydown
  # Work is a virtual lilypond document. It can contain multiple movements,
  # and each movement can contain multiple parts. Each part can contain multiple
  # streams: music, lyrics, figured bass.
  #
  # A Work instance is created in order to translate lydown code into a
  # virtual lilypond document, and then render it. The actual rendering may
  # include all of the streams in the document, or only a selection,such as a
  # specific movement, a specific part, or a specific stream type.
  class Work
    attr_accessor :context

    def initialize(opts = {})
      @context = WorkContext.new(opts)

      process_work_files if opts[:path]
    end
    
    def translate(stream)
      @context.translate(stream)
    end

    def to_lilypond(opts = {})
      @context['render_opts'] = opts
      ly_code = ''

      if opts[:stream_path]
        unless @context[opts[:stream_path]]
          raise LydownError, "Invalid stream path #{opts[:stream_path].inspect}"
        end
        @context[opts[:stream_path]].strip
      else
        @original_context = @context
        begin
          filtered = @context.filter(opts)
          filtered.extend(TemplateBinding)
          Lydown::Templates.render(:lilypond_doc, filtered)
        ensure
          @context = @original_context
        end
      end
    end

    def process_work_files
      path = @context[:options][:path]
      path += '.ld' if File.file?(path + '.ld')

      if File.file?(path)
        process_file(path)
      elsif File.directory?(path)
        process_directory(path)
      else
        raise LydownError, "Could not read #{path}"
      end
    end

    def process_file(path, prefix = [], opts = {})
      $stderr.puts path
      content = IO.read(path)
      stream = LydownParser.parse(content, {
        filename: File.expand_path(path),
        source: content,
        proof_mode: @context['options/proof_mode']
      })
      
      if opts[:line_range]
        Lydown::Rendering.insert_skip_markers(stream, opts[:line_range])
      end
      
      @context.translate(prefix + stream)
    end

    DEFAULT_BASENAMES = %w{work movement}

    def process_directory(path)
      state = {
        streams:          {},
        movements:        Hash.new {|h, k| h[k] = {}},
        current_movement: nil,
        part_count:       0,
        part_filter:      @context[:options][:parts],
        mvmt_filter:      @context[:options][:movements]
      }
      
      read_directory(path, true, state)
      parse_directory_files(state)
      translate_directory_streams(state)
    end
    
    def read_directory(path, recursive, state)
      streams = state[:streams]
      movements = state[:movements]
      
      # look for work code
      file_path = File.join(path, 'work.ld')
      if File.file?(file_path)
        streams[file_path] = nil
        movements[nil][:work] = file_path
      end
      
      # look for movement code
      file_path = File.join(path, 'movement.ld')
      if File.file?(file_path)
        streams[file_path] = nil
        movements[state[:current_movement]][:movement] = file_path
      end
      
      Dir["#{path}/*"].entries.sort.each do |entry|
        handle_directory_entry(entry, recursive, state)
      end
    end
    
    def handle_directory_entry(entry, recursive, state)
      if File.file?(entry) && (entry =~ /\.ld$/)
        part = File.basename(entry, '.*')
        unless skip_part?(part, state)
          state[:streams][entry] = nil
          state[:movements][state[:current_movement]][part] = entry
          state[:part_count] += 1
        end
      elsif File.directory?(entry) && recursive
        movement = File.basename(entry)
        unless skip_movement?(movement, state)
          state[:current_movement] = movement
          read_directory(entry, false, state)
        end
      end
    end
    
    def skip_part?(part, state)
      DEFAULT_BASENAMES.include?(part) ||
        state[:part_filter] && !state[:part_filter].include?(part)
    end
    
    def skip_movement?(mvmt, state)
      state[:mvmt_filter] && !state[:mvmt_filter].include?(mvmt)
    end

    PARALLEL_PARSE_OPTIONS = {
      progress: {
        title: 'Parse',
        format: Lydown::CLI::PROGRESS_FORMAT
      }
    }
    
    PARALLEL_PROCESS_OPTIONS = {
      progress: {
        title: 'Process',
        format: Lydown::CLI::PROGRESS_FORMAT
      }
    }
    
    def parse_directory_files(state)
      streams = state[:streams]
      proof_mode =  @context['options/proof_mode']
      paths = streams.keys

      processed_streams = Parallel.map(paths, PARALLEL_PARSE_OPTIONS) do |path|
        content = IO.read(path)
        LydownParser.parse(content, {
          filename: File.expand_path(path),
          source: content,
          proof_mode: proof_mode,
          no_progress: true
        })
      end
      processed_streams.each_with_index {|s, idx| streams[paths[idx]] = s}
    end
    
    def translate_directory_streams(state)
      # Process work file
      if path = state[:movements][nil][:work]
        @context.translate state[:streams][path]
      end
      
      translate_movement_files(state)
    end
    
    def translate_movement_files(state)
      stream_entries = prepare_work_stream_array(state)
      processed_contexts = Parallel.map(stream_entries, PARALLEL_PROCESS_OPTIONS) do |entry|
        mvmt_stream, stream = *entry
        ctx = @context.clone_for_translation
        ctx.translate(mvmt_stream)
        ctx.translate(stream)
        ctx
      end
      
      processed_contexts.each {|ctx| @context.merge_movements(ctx)}
    end
    
    # An array containing entries for each file/stream to be translated.
    # Each entry in this array is in the form [mvmt_stream, stream]
    def prepare_work_stream_array(state)
      streams = state[:streams]
      movements = state[:movements]
      line_range = @context[:options][:line_range]
      entries = []

      movements.each do |mvmt, mvmt_files|
        # Construct movement stream, a prefix for the part stream
        mvmt_stream = [{type: :setting, key: 'movement', value: mvmt}]
        if path = movements[mvmt][:movement]
          mvmt_stream += streams[path]
        end

        mvmt_files.each do |part, path|
          unless part.is_a?(Symbol)
            stream = streams[path]
            Lydown::Rendering.insert_skip_markers(stream, line_range) if line_range
            stream.unshift({type: :setting, key: 'part', value: part})
            entries << [mvmt_stream, stream]
          end
        end
      end
      entries
    end
    
  end
end
