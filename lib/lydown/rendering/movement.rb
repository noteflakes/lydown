module Lydown::Rendering
  module Movement
    def self.movement_title(context, name)
      return nil if name.nil? || name.empty?
      
      if t = context.get_setting('movement_title', movement: name)
        title = t
      elsif name =~ /^(?:([0-9]+)([a-z]*))\-(.+)$/
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
      'before and after' => {before: true, after: true},
      'blank page before' => {blank_page_before: true},
      'bookpart before' => {bookpart_before: true}
    }
    
    def self.page_breaks(context, opts)
      setting = case context.render_mode
      when :score
        context.get_setting('score/page_break', opts)
      when :part
        part = opts[:part] || context[:part] || context['render_opts/parts']
        
        context.get_setting(:page_break, opts.merge(part: part)) ||
          context.get_setting('parts/page_break', opts)
      else
        {}
      end
      
      PAGE_BREAKS[setting] || {}
    end
    
    # Groups movements by bookparts. Whenever a movement requires a page break
    # before, a new group is created
    def self.bookparts(context, opts)
      groups = []; current_group = []
      context[:movements].keys.each do |movement|
        breaks = page_breaks(context, opts.merge(movement: movement))
        if breaks[:before] || breaks[:blank_page_before]
          groups << current_group unless current_group.empty?
          current_group = []
        end
        current_group << movement
      end
      groups << current_group unless current_group.empty?
      
      groups
    end
    
    def self.hide_bar_numbers?(context, opts)
      context.get_setting(:bar_numbers, opts) == 'hide'
    end
    
    
  end
end