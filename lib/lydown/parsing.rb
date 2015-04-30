require 'treetop'

require 'lydown/parsing/nodes'

include Lydown::Parsing

Treetop.load './lib/lydown/parsing/lydown'

class LydownParser
  def self.parse(source)
    parser = self.new
    ast = parser.parse(source)
    unless ast
      error_info = "Failed to compile: #{parser.failure_reason}\n  #{source.lines[parser.failure_line - 1]}\n #{' ' * parser.failure_column}^"
      STDERR.puts error_info
      raise LydownError, error_info
    else
      ast.to_stream
    end
  end
end