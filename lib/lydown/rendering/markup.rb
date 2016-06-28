module Lydown::Rendering
  module Markup
    def self.convert(str)
      convert_line_breaks(str)
    end
    
    def self.convert_styling(str)
      str.
        gsub(/__([^_]+)__/) {|m| "\\bold {#{$1} }" }.
        gsub(/_([^_]+)_/) {|m| "\\italic {#{$1} }" }
        gsub(/\^([^\^]+)\^/) {|m| "\\smallCaps {#{$1} }" }
    end
    
    def self.convert_line_breaks(str)
      if str =~/\n/
        lines = str.lines.map {|s| "\\fill-line { \"#{s.chomp}\" }"}
        "\\markup \\column { #{lines.join(' ')} }"
      else
        "\"#{str}\""
      end
    end
  end
end
