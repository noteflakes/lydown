module Lydown::Rendering
  module Staff
    def self.staff_groups(context, opts, parts)
      model = context.get_setting('score/order', opts)
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
    
    # returns a hierarchy of staffgroups, each containing group configuration
    # and a list of parts
    def self.staff_group_hierarchy(context, staff_groups)
      staff_groups.map {|group|
        {
          class: 'StaffGroup',
          config: staff_group_config(context, group),
          parts:  group
        }
      }
    end
    
    VOCAL_GROUP_SPAN_BAR_OVERRIDE = 
      "\\override SpanBar #'break-visibility = #'#( #t #f #t )"
    
    def self.staff_group_config(context, group)
      if is_vocal_group?(group)
        VOCAL_GROUP_SPAN_BAR_OVERRIDE
      else
        ''
      end
    end
    
    VOCAL_PARTS = %w{
      soprano alto tenore basso soprano1 soprano2 alto1 alto2 tenore1 tenore2
      basso1 basso2 1soprano 2soprano 1alto 2alto 1tenore 2tenore 1basso 2basso
      1soprano1 1soprano2 2soprano1 2soprano2 1alto1 1alto2 2alto1 2alto2
      1tenore1 1tenore2 2tenore1 2tenore2 1basso1 1basso2 2basso1 2basso2
    }
    
    def self.is_vocal_group?(group)
      !!group.find {|part| VOCAL_PARTS.include? part }
    end
    
    def self.clef(context, opts)
      !context.get_setting(:inhibit_first_clef, opts) &&
        context.get_setting(:clef, opts)
    end
    
    def self.prevent_remove_empty(context, opts)
      case context.get_setting(:remove_empty, opts)
      when false, 'false'
        true
      else
        false
      end
    end
    
    def self.midi_instrument(context, opts)
      context.get_setting(:midi_instrument, opts)
    end
    
    def self.beaming_mode(context, opts)
      beaming = context.get_setting(:beaming, opts)
      return nil if beaming.nil?
      
      case beaming
      when 'auto'
        '\\set Staff.autoBeaming = ##t'
      when 'manual'
        '\\set Staff.autoBeaming = ##f'
      else
        raise LydownError, "Invalid beaming mode (#{beaming.inspect})"
      end
    end
    
    def self.staff_id(part)
      title = Lydown::Rendering.default_part_title(part).gsub(/\s+/, '')
      "#{title}Staff"
    end
    
    def self.qualified_part_title(context, opts)
      title = context.get_setting("parts/#{opts[:part]}/title", opts) ||
              Lydown::Rendering.default_part_title(opts[:part])
      title.strip
    end
    
    def self.part_title(context, opts)
      title = qualified_part_title(context, opts)

      if title.empty?
        "#\"\" "
      else
        if context.get_setting('instrument_name_style', opts) == 'smallcaps'
          "\\markup { \\smallCaps { #{title} } } "
        else
          "#\"#{title}\" "
        end
      end
    end
    
    def self.inline_part_title(context, opts)
      title = qualified_part_title(context, opts)

      if title.empty?
        "#\"\""
      else
        if context.get_setting('instrument_name_style', opts) == 'smallcaps'
          "<>^\\markup { #{opts[:alignment]} \\smallCaps { #{title} } } "
        else
          "<>^\\markup { #{opts[:alignment]} { #{title} } } "
        end
      end
    end
    
    def self.end_barline(context, opts)
      return nil if context['global/settings/inhibit_end_barline']
      
      barline = context.get_setting('end_barline', opts)
      barline == 'none' ? nil : barline
    end
  end
end