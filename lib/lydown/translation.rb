module Lydown
  module Translation
    def self.process(source)
      output = ''
      if source[:ripple]
        output << RippleParser.translate(source[:ripple], source)
      end
      if source[:lyrics]
        output << "\n=lyrics\n#{source[:lyrics]}"
      end
      output
    end
  end
end

require 'lydown/translation/ripple'

