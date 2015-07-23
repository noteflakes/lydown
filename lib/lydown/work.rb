require 'lydown/core_ext'
require 'lydown/templates'

require 'pp'

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
      @context = {}.deep!
      reset_context(:work)
      @context[:options] = opts.deep_clone

      process_work_files if opts[:path]
    end

    def reset_context(mode)
      case mode
      when :work
        @context[:time] = '4/4'
        @context[:tempo] = nil
        @context[:cadenza_mode] = nil
        @context[:key] = 'c major'
        @context[:pickup] = nil
        @context[:beaming] = nil
        @context[:end_barline] = nil
        @context[:part] = nil
      when :movement
        @context[:part] = nil
      end
      if @context['process/tuplet_mode']
        Lydown::Rendering::TupletDuration.emit_tuplet_end(self)
      end
      if @context['process/grace_mode']
        Lydown::Rendering::Grace.emit_grace_end(self)
      end
      
      if @context['process/voice_selector']
        Lydown::Rendering::VoiceSelect.render_voices(self)
      end
      
      Lydown::Rendering::Notes.cleanup_duration_macro(self)

      # reset processing variables
      @context['process'] = {
        'duration_values' => ['4'],
        'running_values' => []
      }
    end

    # Used to bind to instance when rendering templates
    def template_binding(locals = {})
      b = binding
      locals.each {|k, v| b.local_variable_set(k.to_sym, v)}
      b
    end

    # translate a lydown stream into lilypond
    def process(lydown_stream, opts = {})
      lydown_stream.each_with_index do |e, idx|
        if e[:type]
          Lydown::Rendering.translate(self, e, lydown_stream, idx)
        else
          raise LydownError, "Invalid lydown stream event: #{e.inspect}"
        end
      end
      reset_context(:part) unless opts[:no_reset]
    end

    def emit(path, *content)
      stream = current_stream(path)

      content.each {|c| stream << c}
    end

    def current_stream(subpath)
      if @context['process/voice_selector']
        path = "process/voices/#{@context['process/voice_selector']}/#{subpath}"
      else
        movement = @context[:movement]
        part = @context[:part]
        path = "movements/#{movement}/parts/#{part}/#{subpath}"
      end
      @context[path] ||= (subpath == :settings) ? {} : ''
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
          @context = filter_context(opts)
          Lydown::Templates.render(:lilypond_doc, self)
        ensure
          @context = @original_context
        end
      end
    end

    def filter_context(opts = {})
      filtered = @context.deep_clone

      if filtered['movements'].nil? || filtered['movements'].size == 0
        # no movements found, so no music
        raise LydownError, "No music found"
      elsif filtered['movements'].size > 1
        # delete default movement if other movements are present
        filtered['movements'].delete('')
      end

      if opts[:movements]
        opts[:movements] = [opts[:movements]] unless opts[:movements].is_a?(Array)
        filtered['movements'].select! do |name, m|
          opts[:movements].include?(name.to_s)
        end
      end

      if opts[:parts]
        opts[:parts] = [opts[:parts]] unless opts[:parts].is_a?(Array)
      end
      filtered['movements'].each do |name, m|
        # delete default part if other parts are present
        if m['parts'].size > 1
          m['parts'].delete('')
        end

        if opts[:parts]
          m['parts'].select! do |pname, p|
            opts[:parts].include?(pname.to_s)
          end
        end
      end

      filtered
    end

    def compile(opts = {})
      code = to_lilypond(opts)

      Lydown::Lilypond.compile(code, opts)
    end

    def [](path)
      context[path]
    end

    def []=(path, value)
      context[path] = value
    end
    
    # Helper method to preserve context while processing a file or directory.
    # This method is called with a block. After the block is executed, the 
    # context is restored.
    def preserve_context
      old_context = @context
      new_context = old_context.deep_merge({})
      @context = new_context
      yield
    ensure
      @context = old_context
      if new_context['movements']
        if @context['movements']
          @context['movements'].deep_merge! new_context['movements']
        else
          @context['movements'] = new_context['movements']
        end
        if @context['movements/01-intro/parts/violino1/settings'] && @context['movements/01-intro/parts/violino1/settings'].keys.include?('pickup')
        end
      end
    end
    
    def set_part_context(part)
      movement = @context[:movement]
      path = "movements/#{movement}/parts/#{part}/settings"

      settings = {}.deep!
      settings[:pickup] = @context[:pickup]
      settings[:key] = @context[:key]
      settings[:tempo] = @context[:tempo]
      
      @context[path] = settings
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

    def process_directory(path, recursive = true)
      puts "process_directory #{@context[:options].inspect}"
      preserve_context do
        # process work code
        process_lydown_file(File.join(path, 'work.ld'))
        # process movement specific code
        process_lydown_file(File.join(path, 'movement.ld'))
        
        part_filter = @context[:options][:parts]
        mvmt_filter = @context[:options][:movements]
        
        # Iterate over sorted directory entries
        Dir["#{path}/*"].entries.sort.each do |entry|
          if File.file?(entry) && (entry =~ /\.ld$/)
            part = File.basename(entry, '.*')
            skip = part_filter && !part_filter.include?(part)
            unless DEFAULT_BASENAMES.include?(part) || skip
              preserve_context do
                process_lydown_file(entry, [
                  {type: :setting, key: 'part', value: part}
                ], line_range: @context[:options][:line_range])
              end
            end
          elsif File.directory?(entry) && recursive
            movement = File.basename(entry)
            skip = mvmt_filter && !mvmt_filter.include?(movement)
            unless skip
              process([{type: :setting, key: 'movement', value: movement}])
              process_directory(entry, false)
            end
          end
        end
      end
    end
    
    def process_lydown_file(path, prefix = [], opts = {})
      puts "process: #{path}"
      return unless File.file?(path)

      content = IO.read(path)
      stream = LydownParser.parse(content, {
        filename: File.expand_path(path),
        source: content
      })
      
      if opts[:line_range]
        Lydown::Rendering.insert_skip_markers(stream, opts[:line_range])
      end
      
      process(prefix + stream)
    end
  end
end
