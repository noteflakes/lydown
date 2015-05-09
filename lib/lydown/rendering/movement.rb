module Lydown::Rendering
  module Movement
    def self.movement_title(name)
      return nil if name.nil? || name.empty?
      
      if name =~ /^(?:([0-9])+([a-z]*))\-(.+)$/
        "#{$1.to_i}#{$2}. #{$3.capitalize}"
      else
        name
      end
    end
  end
end