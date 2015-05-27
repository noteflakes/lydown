require File.expand_path("./lib/lydown/version", File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name          = 'lydown'
  s.version       = Lydown::VERSION

  s.summary       = "Lydown is a language for music notation"
  s.description   = "Lydown is a language and tool for music notation"
  s.authors       = ["Sharon Rosner"]
  s.email         = 'ciconia@gmail.com'

  s.homepage      = 'http://github.com/ciconia/lydown'
  s.license       = 'MIT'

  s.require_path  = 'lib'
  s.files         = Dir["{lib}/**/*", "bin/*", "LICENSE", "README.md"]

  s.executables   = ['lydown']

  s.add_dependency "treetop", "~> 1.6"
end
