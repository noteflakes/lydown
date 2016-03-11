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

    def self.to_pp(v)
      if v =~ /([0-9\-\.])(mm|cm)/
        value = $1
        unit = $2
        
        factor = POINT_DIV[unit.to_sym]
        value.to_f / factor
      else
        raise "Invalid measurement #{v}"
      end
    end
    
    def self.v_unit(v)
    end
  end
end


