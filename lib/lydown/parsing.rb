require 'polyglot'
require 'treetop'

require 'lydown/parsing/nodes'
require 'lydown/parsing/lydown.treetop'

class LydownParser
  def self.parse(source, opts = {})
    parser = self.new
    ast = parser.parse(source)
    unless ast
      error_msg = format_parser_error(source, parser, opts)
      STDERR.puts error_msg
      raise LydownError, error_msg
    else
      stream = []
      # insert source ref event into stream if we have a filename ref
      stream << {type: :source_ref}.merge(opts) if opts[:filename]
      ast.to_stream(stream, opts)
    end
  end

  def self.format_parser_error(source, parser, opts)
    msg = opts[:source_filename] ? "#{opts[:source_filename]}: " : ""
    if opts[:nice_error]
      msg << "Unexpected character at line #{parser.failure_line} column #{parser.failure_column}:\n"
    else
      msg << "#{parser.failure_reason}:\n"
    end
    msg << "  #{source.lines[parser.failure_line - 1].chomp}\n #{' ' * parser.failure_column}^"

    msg
  end
end
