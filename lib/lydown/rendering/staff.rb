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
    
    BRACKET_PARTS = %w{soprano alto tenore basso soprano1 soprano2 
      alto1 alto2 tenore1 tenore2 basso1 basso2}
    
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
      directive = nil
      expr = staff_groups.inject('') do |m, group|
        directive = staff_group_directive(group)
        if directive
          m << "(#{directive} #{group.join(' ')}) "
        else
          m << "#{group.join(' ')} "
        end
        m
      end
      
      if (staff_groups.size == 1) && (staff_groups[0].size > 1) && directive == "SystemStartBracket"
        # If all staves are already group, no need to add the system bracket
        "#'#{expr}"
      else
        "#'(SystemStartBracket #{expr})"
      end
    end
    
    def self.clef(part)
      DEFAULTS["parts/#{part}/clef"]
    end
    
    def self.prevent_remove_empty(part)
      DEFAULTS["parts/#{part}/remove_empty"] == false
    end
    
    def self.midi_instrument(part)
      DEFAULTS["parts/#{part}/midi_instrument"]
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
    
    def self.staff_id(part)
      title = Lydown::Rendering.part_title(part).gsub(/\s+/, '')
      "#{title}Staff"
    end
    
    def self.part_title(context, part, name = nil)
      title = name || Lydown::Rendering.part_title(part)
      title.strip!

      if title.empty?
        "#\"\" "
      else
        if context['instrument_name_style'] == 'smallcaps'
          "\\markup { \\smallCaps { #{title} } } "
        else
          "#\"#{title}\" "
        end
      end
    end
    
    def self.inline_part_title(context, opts)
      title = opts[:name] || Lydown::Rendering.part_title(opts[:part])
      title.strip!

      if title.empty?
        "#\"\""
      else
        if context['instrument_name_style'] == 'smallcaps'
          "<>^\\markup { #{opts[:alignment]} \\smallCaps { #{title} } } "
        else
          "<>^\\markup { #{opts[:alignment]} { #{title} } } "
        end
      end
    end
    
    DEFAULT_END_BARLINE = '|.'
    
    def self.end_barline(context, movement)
      barline = movement['end_barline'] || context['end_barline'] || DEFAULT_END_BARLINE
      barline == 'none' ? nil : barline
    end
  end
end