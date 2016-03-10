require 'lydown/templates'
require 'lydown/work'
require 'lydown/rendering/base'
require 'lydown/rendering/literal'
require 'lydown/rendering/comments'
require 'lydown/rendering/lyrics'
require 'lydown/rendering/notes'
require 'lydown/rendering/music'
require 'lydown/rendering/repeats'
require 'lydown/rendering/settings'
require 'lydown/rendering/staff'
require 'lydown/rendering/movement'
require 'lydown/rendering/command'
require 'lydown/rendering/voices'
require 'lydown/rendering/source_ref'
require 'lydown/rendering/skipping'

module Lydown::Rendering
  class << self
    def translate(work, e, lydown_stream, idx)
      klass = class_for_event(e)
      klass.new(e, work, lydown_stream, idx).translate
    end
    
    def class_for_event(e)
      Lydown::Rendering.const_get(e[:type].to_s.camelize)
    rescue
      raise LydownError, "Invalid lydown event: #{e.inspect}"
    end
    
    def default_part_title(part_name)
      if part_name =~ /^([^\d]+)(\d+)$/
        "#{$1.titlize} #{$2.to_i.to_roman}"
      else
        part_name.titlize
      end
    end
    
    def variable_name_infix(infix)
      infix.capitalize.gsub(/(\d+)/) {|n| n.to_i.to_roman.upcase}.
        gsub(/[^a-zA-Z]/, '').gsub(/\s+/, '')
    end
    
    VOICE_INDEX = {
      '1' => 'One',
      '2' => 'Two',
      '3' => 'Three',
      '4' => 'Four'
    }
    
    def voice_variable_name_infix(infix)
      infix.capitalize.gsub(/(\d+)/) {|n| VOICE_INDEX[n]}
    end
    
    def variable_name(opts)
      varname = "%s/%s/%s" % [
        opts[:movement],
        opts[:part],
        opts[:stream]
      ]
      
      varname << "/#{opts[:voice]}" if opts[:voice]
      varname << "/#{opts[:idx]}" if opts[:idx]
      
      "\"#{varname}\""
    end
    
    def add_includes(filenames, context, key, opts)
      includes = context.get_setting(key, opts)
      filenames.concat(includes) if includes
    end
    
    def include_files(context, opts)
      filenames = []
      if opts.has_key?(:movement)
        add_includes(filenames, context, :includes, opts)
        case context.render_mode
        when :score
          add_includes(filenames, context, 'score/includes', opts)
        when :part
          add_includes(filenames, context, 'parts/includes', opts)
          if opts[:part]
            add_includes(filenames, context, "parts/#{opts[:part]}/includes", opts)
          end
        end
      else
        # paths to be included at top of lilypond doc should be defined under
        # document/includes
        add_includes(filenames, context, 'document/includes', opts)
      end
      
      filenames.map do |fn|
        case File.extname(fn)
        when '.ely'
          Lydown::Templates.render(fn, context)
        else
          "\\include \"#{fn}\""
        end
      end
    end
    
    def add_requires(packages, context, key, opts)
      requires = context.get_setting(key, opts)
      packages.concat(requires) if requires
    end
    
    def packages_to_load(context, opts)
      packages = []
      if opts.has_key?(:movement)
        add_requires(packages, context, :requires, opts)
        case context.render_mode
        when :score
          add_requires(packages, context, 'score/requires', opts)
        when :part
          add_requires(packages, context, 'parts/requires', opts)
          if opts[:part]
            add_requires(packages, context, "parts/#{opts[:part]}/requires", opts)
          end
        end
      else
        # paths to be included at top of lilypond doc should be defined under
        # document/requires
        add_requires(packages, context, 'document/requires', opts)
      end
      
      packages.uniq
    end      
  end
end

LY_LIB_DIR = File.join(File.dirname(__FILE__), 'ly_lib')