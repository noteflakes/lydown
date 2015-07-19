module Lydown
  module Translation
    def self.process(source)
      code = ''
      if source[:ripple]
        RippleParser.translate(source[:ripple], source)
      end
    end
  end
end

require 'lydown/translation/ripple'

