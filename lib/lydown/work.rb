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
      @context = WorkContext.new(self, opts)

      process_work_files if opts[:path]
    end

    # translate a lydown stream into lilypond
    def process(lydown_stream, opts = {})
      lydown_stream.each_with_index do |e, idx|
        if e[:type]
          Lydown::Rendering.translate(@context, e, lydown_stream, idx)
        else
          raise LydownError, "Invalid lydown stream event: #{e.inspect}"
        end
      end
      @context.reset(:part) unless opts[:no_reset]
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

    def compile(opts = {})
      code = to_lilypond(opts)

      Lydown::Lilypond.compile(code, opts)
    end

    def process_work_files
      path = @context[:options][:path]
      path += '.ld' if File.file?(path + '.ld')

      if File.file?(path)
        process_lydown_file(path)
      elsif File.directory?(path)
        process_directory(path)
      else
        raise LydownError, "Could not read #{path}"
      end
    end

    DEFAULT_BASENAMES = %w{work movement}

    def process_directory(path)
      state = {
        streams: {},
        movements: Hash.new {|h, k| h[k] = {}},
        current_movement: nil,
        part_count: 0
      }
      
      read_directory(path, true, state)
      parse_directory_files(state)
      process_directory_files(state)
    end
    
    def read_directory(path, recursive, state)
      streams = state[:streams]
      movements = state[:movements]
      current_movement = state[:current_movement]
      part_filter = @context[:options][:parts]
      mvmt_filter = @context[:options][:movements]
      
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
        movements[current_movement][:movement] = file_path
      end

      Dir["#{path}/*"].entries.sort.each do |entry|
        if File.file?(entry) && (entry =~ /\.ld$/)
          part = File.basename(entry, '.*')
          skip = part_filter && !part_filter.include?(part)
          unless DEFAULT_BASENAMES.include?(part) || skip
            streams[entry] = nil
            movements[current_movement][part] = entry
            state[:part_count] += 1
          end
        elsif File.directory?(entry) && recursive
          movement = File.basename(entry)
          skip = mvmt_filter && !mvmt_filter.include?(movement)
          unless skip
            state[:current_movement] = movement
            # process([{type: :setting, key: 'movement', value: movement}])
            read_directory(entry, false, state)
          end
        end
      end
    end

    PARALLEL_PARSE_OPTIONS = {
      progress: {
        title: 'Parse',
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
    
    def process_directory_files(state)
      streams = state[:streams]
      movements = state[:movements]

      Lydown::CLI.show_progress('Process', state[:part_count]) do |bar|
        @context.preserve do
          if path = movements[nil][:work]
            process(streams[path])
          end
        
          movements.each do |mvmt, paths|
            process_movement_directory_files(mvmt, state)
          end
        end
        bar.finish
      end
    end
    
    def process_movement_directory_files(mvmt, state)
      streams = state[:streams]
      movements = state[:movements]
      line_range = @context[:options][:line_range]

      process([{type: :setting, key: 'movement', value: mvmt}]) unless mvmt.nil?
      @context.preserve do
        if path = movements[mvmt][:movement]
          process(streams[path])
        end
        
        movements[mvmt].each do |part, path|
          unless part.is_a?(Symbol) # :work, :movement
            @context.preserve do
              stream = streams[path]
              if line_range
                Lydown::Rendering.insert_skip_markers(stream, line_range)
              end
              stream.unshift({type: :setting, key: 'part', value: part})
              $progress_bar.increment if $progress_bar
              process(stream)
            end
          end
        end
      end
    end
    
    def process_lydown_file(path, prefix = [], opts = {})
      return unless File.file?(path)

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
      
      process(prefix + stream)
    end
  end
end
