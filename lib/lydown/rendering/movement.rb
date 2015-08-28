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
    
    PAGE_BREAKS = {
      'before' => {before: true},
      'after'  => {after: true},
      'before and after' => {before: true, after: true}
    }
    
    def self.page_breaks(context)
      case context['render_opts/mode']
      when :score
        PAGE_BREAKS[context['score/page_break']] || {}
      when :part
        part = context['part']
        PAGE_BREAKS[context["parts/#{part}/page_break"]] || {}
      else
        {}
      end
    end
  end
end