module Lydown::Rendering
  module Staff
    def self.staff_groups(context, movement, parts)
      model = context['score/order'] || movement['score/order'] || DEFAULTS['score/order']
      parts_copy = parts.clone
      
      groups = []
      
      model.each do |group|
        group = [group] unless group.is_a?(Array)
        filtered = group.select do |p|
          if parts_copy.include?(p)
            parts_copy.delete(p)
            true
          end
        end
        groups << filtered unless filtered.empty?
      end
      
      # add any remaining unknown parts, in their original order
      parts_copy.each {|p| groups << [p]}
      
      groups
    end
    
    SYSTEM_START = {
      "brace" => "SystemStartBrace",
      "bracket" => "SystemStartBracket"
    }
    
    BRACKET_PARTS = %w{soprano alto tenore basso}
    
    def self.staff_group_directive(group)
      if group.size == 1
        nil
      elsif BRACKET_PARTS.include?(group.first)
        "SystemStartBracket"
      else
        "SystemStartBrace"
      end
    end
    
    # renders a systemStartDelimiterHierarchy expression
    def self.staff_hierarchy(staff_groups)
      expr = staff_groups.inject('') do |m, group|
        directive = staff_group_directive(group)
        if directive
          m << "(#{directive} #{group.join(' ')}) "
        else
          m << "#{group.join(' ')} "
        end
        m
      end
        
      "#'(SystemStartBracket #{expr})"
    end
    
    def self.clef(part)
      DEFAULTS["parts/#{part}/clef"]
    end
    
    def self.beaming_mode(part)
      beaming = DEFAULTS["parts/#{part}/beaming"]
      return nil if beaming.nil?
      
      case beaming
      when 'auto'
        '\autoBeamOn'
      when 'manual'
        '\autoBeamOff'
      else
        raise LydownError, "Invalid beaming mode (#{beaming.inspect})"
      end
    end
    
    DEFAULT_END_BARLINE = '|.'
    
    def self.end_barline(context, movement)
      barline = movement['end_barline'] || context['end_barline'] || DEFAULT_END_BARLINE
      barline == 'none' ? nil : barline
    end
  end
end