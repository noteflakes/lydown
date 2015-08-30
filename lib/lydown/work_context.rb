module Lydown
  # A WorkContext instance holds the entire state of a work being processed.
  # This includes both the document settings and processing state, and the
  # resulting lilypond streams and associated data.
  class WorkContext
    attr_reader :context
    
    include TemplateBinding
    
    def initialize(opts = {}, context = nil)
      if context
        @context = context
      else
        @context = {}.deep!
        reset(:work)
        @context[:options] = opts.deep_clone
      end
    end
    
    # process lydown stream by translating into self
    def translate(stream, opts = {})
      stream.each_with_index do |e, idx|
        if e[:type]
          Lydown::Rendering.translate(self, e, stream, idx)
        else
          raise LydownError, "Invalid lydown stream event: #{e.inspect}"
        end
      end
      reset(:part) unless opts[:macro_group]
    end

    def reset(mode)
      case mode
      when :work
        @context[:part] = nil
        set_setting(:time, '4/4')
        set_setting(:tempo, nil)
        @context[:cadenza_mode] = nil
        set_setting(:key, 'c major')
        set_setting(:pickup, nil)
        set_setting(:beaming, nil)
        set_setting(:end_barline, nil)
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

    def clone_for_translation
      new_context = @context.deep_merge({'movements' => nil})
      WorkContext.new(nil, new_context)
    end
    
    def merge_movements(ctx)
      return unless ctx['movements']
      if @context['movements']
        @context['movements'].deep_merge! ctx['movements']
      else
        @context['movements'] = ctx['movements']
      end
    end
    
    def filter(opts = {})
      filtered = @context.deep_clone

      if filtered[:movements].nil? || filtered[:movements].size == 0
        # no movements found, so no music
        raise LydownError, "No music found"
      elsif filtered[:movements].size > 1
        # delete default movement if other movements are present
        filtered[:movements].delete('')
      end

      if filter = opts[:movements]
        filter = [filter] unless filter.is_a?(Array)
        filtered[:movements].select! {|name, m| filter.include?(name.to_s)}
      end

      if filter = opts[:parts]
        filter = [filter] unless filter.is_a?(Array)
        filter += opts[:include_parts] if opts[:include_parts]
      end
      filtered[:movements].each do |name, m|
        # delete default part if other parts are present
        if m[:parts].size > 1
          m[:parts].delete('')
        end

        if filter
          m[:parts].select! do |pname, p|
            filter.include?(pname.to_s)
          end
        end
      end

      WorkContext.new(nil, filtered)
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
    
    def settings_path(movement, part)
      if part
        "movements/#{movement}/parts/#{part}/settings"
      elsif movement && !movement.empty?
        "movements/#{movement}/settings"
      else
        "global/settings"
      end
    end
    
    def query_setting(movement, part, path)
      path = "#{settings_path(movement, part)}/#{path}"
      value = @context[path]
      unless value.nil?
        @temp_setting_value = value
        true
      else
        false
      end
    end
    
    def query_defaults(path)
      value = DEFAULTS[path]
      unless value.nil?
        @temp_setting_value = value
        true
      else
        false
      end
    end
    
    def get_setting(path, opts = {})
      # In order to allow false values for settings, we create
      # a temporary instance variable, and use it to store the
      # setting value once it's found. That way we can use the
      # || operator to stop searching once we've found it.
      @temp_setting_value = nil
      if opts[:part]
        parts_section_path = "parts/#{opts[:part]}/#{path}"
        
        query_setting(opts[:movement], opts[:part], path) ||
        query_setting(nil, opts[:part], path) ||
        query_setting(opts[:movement], nil, path) ||
        query_setting(nil, nil, path) ||
        
        # search in parts section
        query_setting(opts[:movement], nil, parts_section_path) ||
        query_setting(nil, nil, parts_section_path) ||
        
        query_defaults("parts/#{opts[:part]}/#{path}") ||
        query_defaults(path)
      else
        query_setting(opts[:movement], nil, path) || 
        query_setting(nil, nil, path) || 
        query_defaults(path)
      end
      @temp_setting_value
    end
    
    # Get setting while code is being translated
    def get_current_setting(path)
      get_setting(path, current_setting_opts)
    end
    
    def current_setting_opts
      {movement: @context[:movement], part: @context[:part]}
    end
    
    def set_setting(path, value)
      path = "#{settings_path(@context[:movement], @context[:part])}/#{path}"
      @context[path] = value
    end
  end
end
