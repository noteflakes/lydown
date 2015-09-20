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

  s.add_dependency "treetop", "1.6.2"
  s.add_dependency "diff-lcs", "1.2.5"
  s.add_dependency "escape_utils", "1.0.0"
  s.add_dependency "thor", "0.19.1"
  s.add_dependency "directory_watcher", "1.5.1"
  s.add_dependency "ruby-progressbar", "1.7.5"
  s.add_dependency "parallel", "1.6.1"
  s.add_dependency "msgpack", "0.6.2"
  s.add_dependency "combine_pdf", "0.2.5"

  s.add_dependency "rspec", "3.2.0"
end
