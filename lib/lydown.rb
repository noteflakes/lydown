require 'lydown/core_ext'

module Lydown
  require 'yaml'
  DEFAULTS = YAML.load(IO.read(File.join(File.dirname(__FILE__), 
    'lydown/defaults.yml'))).deep!
end

require 'lydown/errors'
require 'lydown/parsing'
require 'lydown/templates'
require 'lydown/rendering'
require 'lydown/lilypond'
require 'lydown/work_context'
require 'lydown/work'
require 'lydown/translation'