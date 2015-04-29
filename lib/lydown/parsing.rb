require 'treetop'

require 'lydown/parsing/nodes'

include Lydown::Parsing

Treetop.load './lib/lydown/parsing/lydown'

class LydownParser
  def self.parse(source)
    ast = self.new.parse(source)
    unless ast
      STDERR.puts "Faild to compile"
      STDERR.puts parser.failure_reason
      STDERR.puts "  #{source.lines[parser.failure_line - 1]}"
      STDERR.puts " #{' ' * parser.failure_column}^"
      raise LydownError, "Failed to compile"
    else
      ast.to_stream
    end
  end
end