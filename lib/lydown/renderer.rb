require 'lydown/templates'

module Lydown::Renderer
  class << self
    def render_movement(name, movement)
      puts "render_movement(#{name.inspect}, #{movement.inspect})"
      Lydown::Templates.render(:movement, name: name, movement: movement)
    end
    
    def render_part(name, part)
      puts "render_part(#{name.inspect}, #{part.inspect})"
      Lydown::Templates.render(:part, name: name, part: part)
    end
  end
end