module Lydown::Rendering
  module Movement
    def self.movement_title(context, name)
      return nil if name.nil? || name.empty?
      
      if name =~ /^(?:([0-9]+)([a-z]*))\-(.+)$/
        title = "#{$1.to_i}#{$2}. #{$3.capitalize}"
      else
        title = name
      end
      
      if context["movements/#{name}/parts"].empty?
        title += " - tacet"
      end
      
      title
    end
    
    def self.tacet?(context, name)
      context["movements/#{name}/parts"].empty?      
    end
    
    PAGE_BREAKS = {
      'before' => {before: true},
      'after'  => {after: true},
      'before and after' => {before: true, after: true}
    }
    
    def self.page_breaks(context, opts)
      setting = case context.render_mode
      when :score
        context.get_setting('score/page_break', opts)
      when :part
        part = context[:part] || context['options/parts']
        context.get_setting(:page_break, opts.merge(part: part)) ||
          context.get_setting('parts/page_break', opts)
      else
        {}
      end
      
      PAGE_BREAKS[setting] || {}
    end
    
    def self.include_files(context, opts)
      (context.get_setting(:includes, opts) || []).map do |fn|
        case File.extname(fn)
        when '.ely'
          Lydown::Templates.render(fn, context)
        else
          "\\include \"#{fn}\""
        end
      end
    end
  end
end