$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'lydown/core_ext'
require 'lydown/cache'

module Lydown
  require 'yaml'
  
  DEFAUTLS_FILENAME = File.expand_path('lydown/defaults.yml', File.dirname(__FILE__))
  DEFAULTS = YAML.load(IO.read(DEFAUTLS_FILENAME)).deep!
end

require 'lydown/errors'
require 'lydown/parsing'
require 'lydown/templates'
require 'lydown/inverso'
require 'lydown/rendering'
require 'lydown/lilypond'
require 'lydown/work_context'
require 'lydown/work'
require 'lydown/translation'