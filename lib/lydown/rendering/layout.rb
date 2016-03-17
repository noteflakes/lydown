# encoding: utf-8

require 'fileutils'
require 'pathname'

module Lydown::Rendering
  module Layout
    def self.define_paper_size(layout)
      return "" unless layout[:paper]
      
      if layout[:paper] =~ /([^\s]+)\s?(portrait|landscape)?/
        size = $1
        orientation = $2 || 'portrait'
      else
        size = layout[:paper]
        orientation = 'portrait'
      end
      
      "#(set-paper-size \"#{size.downcase}\" '#{orientation})"
    end
    
    POINT_DIV = {
      mm: 0.352778,
      cm: 3.52778
    }

    MEASUREMENT_RE = /^([0-9\-\.]+)(mm|cm)$/

    def self.to_pp(v)
      if v =~ MEASUREMENT_RE
        value = $1
        unit = $2
        
        factor = POINT_DIV[unit.to_sym]
        "%.1f" % (value.to_f / factor)
      else
        raise "Invalid measurement #{v}"
      end
    end
    
    def self.fmt(v)
      if v =~ MEASUREMENT_RE
        "#{$1}\\#{$2}"
      else
        raise "Invalid measurement #{v}"
      end
    end
    
    def self.to_v(v)
      if v =~ MEASUREMENT_RE
        $1.to_f
      else
        raise "Invalid measurement #{v}"
      end
    end
    
    # in points
    def self.staff_space(info)
      to_v(info[:staff_size]) / 4
    end
    
    # calculates inner vertical margins - that is, the space between the defined
    # actual margin (used for header/footer) and the music/markup.
    # an array of four values is returned: top-content, bottom-content
    def self.calculate_vertical_margins(info)
      ss = staff_space(info)
      
      dist = lambda do |k|
        (to_v(info["#{k}_content"]) - to_v(info[k])) / ss
      end
      
      staff_dist = lambda {|k| dist[k] + 2}
      
      [
        "%.1f" % staff_dist[:margin_top],
        "%.1f" % dist[:margin_top],
        "%.1f" % staff_dist[:margin_bottom]
      ].tap {|o| p o}
    end
  end
end


