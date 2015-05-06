module Lydown::Rendering
  module Staves
    def self.staff_groups(work, movement, parts)
      model = work['score/order'] || movement['score/order'] || DEFAULTS['score/order']
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
  end
end