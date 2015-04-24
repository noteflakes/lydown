require File.expand_path("./lib/lydown/version", __FILE__)

Gem::Specification.new do |s|
  s.name          = 'lydown'
  s.version       = Lydown::VERSION

  s.summary       = "Lydown is a language for music notation"
  s.description   = "Lydown "
  s.authors       = ["Sharon Rosner"]
  s.email         = 'ciconia@gmail.com'

  s.homepage      = 'http://github.com/ciconia/lydown'
  s.license       = 'MIT'

  s.files         = Dir["{lib}/**/*", "bin/*", "LICENSE", "*.md"]
  s.require_path  = 'lib'

  s.executables   = ['lydown']
  
  s.add_dependency "treetop", "~> 1.6"
end