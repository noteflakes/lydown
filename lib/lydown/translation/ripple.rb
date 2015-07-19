require 'polyglot'
require 'treetop'

require 'lydown/translation/ripple/nodes'
require 'lydown/translation/ripple/ripple.treetop'

class RippleParser
  def self.parse(source, opts = {})
    parser = self.new
    ast = parser.parse(source)
    unless ast
      error_msg = format_parser_error(source, parser, opts)
      STDERR.puts error_msg
      raise LydownError, error_msg
    end
    ast
  end

  def self.translate(source)
    context = {source: source}
    ast = parse(source)
    stream = ''
    ast.translate(stream, context)
  end

  def self.format_parser_error(source, parser, opts)
    msg = "#{parser.failure_reason} at #{parser.failure_line}:#{parser.failure_column}\n"
    msg << "  #{source.lines[parser.failure_line - 1].chomp}\n #{' ' * parser.failure_column}^"
    msg
  end
end
