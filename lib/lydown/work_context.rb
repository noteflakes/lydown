module Lydown
  # A WorkContext instance holds the entire state of a work being processed.
  # This includes both the document settings and processing state, and the
  # resulting lilypond streams and associated data.
  class WorkContext
    attr_reader :work
    attr_reader :context
    
    include TemplateBinding
    
    def initialize(work, opts = {})
      @work = work
      @context = {}.deep!

      reset(:work)
      @context[:options] = opts.deep_clone
    end
    
    def reset(mode)
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

    # Helper method to preserve context while processing a file or directory.
    # This method is called with a block. After the block is executed, the 
    # context is restored.
    def preserve
      old_context = @context
      new_context = old_context.deep_merge({})
      new_context['movements'] = nil
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
      end
    end
    
    def filter(opts = {})
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

    def [](key)
      @context[key]
    end
    
    def []=(key, value)
      @context[key] = value
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
    
    def set_part_context(part)
      movement = @context[:movement]
      path = "movements/#{movement}/parts/#{part}/settings"

      settings = {}.deep!
      settings[:pickup] = @context[:pickup]
      settings[:key] = @context[:key]
      settings[:tempo] = @context[:tempo]
      
      @context[path] = settings
    end
  end
end
