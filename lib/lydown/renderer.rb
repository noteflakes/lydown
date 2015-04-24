require 'lydown/templates'

module Lydown::Renderer
  class << self
    def render_movement(name, movement)
      Lydown::Templates.render(:movement, name: name, movement: movement)
    end
    
    def render_part(name, part)
      Lydown::Templates.render(:part, name: name, part: part)
    end
  end
end