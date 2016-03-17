module Lydown::Rendering
  module Markup
    def self.convert(str)
      if str =~/\n/
        lines = str.lines.map {|s| "\\fill-line { \"#{s.chomp}\" }"}
        "\\markup \\column { #{lines.join(' ')} }"
      else
        "\"#{str}\""
      end
    end
  end
end
