require 'polyglot'
require 'treetop'

require 'lydown/parsing/nodes'
require 'lydown/parsing/lydown.treetop'

class LydownParser
  def self.parse(source, opts = {})
    if opts[:no_progress]
      do_parse(source, opts)
    else
      Lydown::CLI.show_progress('Parse', source.length * 2) do |bar|
        stream = do_parse(source, opts)
        bar.finish
        stream
      end
    end
  end
  
  def self.do_parse(source, opts)
    parser, ast = self.new
    ast = parser.parse(source)

    unless ast
      error_msg = format_parser_error(source, parser, opts)
      $stderr.puts error_msg
      raise LydownError, error_msg
    else
      stream = []
      ast.to_stream(stream, opts.merge(progress_base: source.length))
      # insert source ref event into stream if we have a filename ref
      if opts[:filename] && !stream.empty?
        stream.unshift({type: :source_ref}.merge(opts))
      end
      stream
    end
  end
  
  def self.parse_macro_group(source, opts)
    parser, ast = self.new, ast = nil
    old_bar, $progress_bar = $progress_bar, nil
    ast = parser.parse(source)
    unless ast
      error_msg = format_parser_error(source, parser, opts)
      $stderr.puts error_msg
      raise LydownError, error_msg
    else
      stream = []
      ast.to_stream(stream, opts)
      stream
    end
  ensure
    $progress_bar = old_bar
  end

  def self.format_parser_error(source, parser, opts)
    msg = opts[:filename] ? "#{opts[:filename]}: " : ""
    if opts[:nice_error]
      msg << "Unexpected character at line #{parser.failure_line} column #{parser.failure_column}:\n"
    else
      msg << "#{parser.failure_reason}:\n"
    end
    msg << "  #{source.lines[parser.failure_line - 1].chomp}\n #{' ' * parser.failure_column}^"

    msg
  end
end
