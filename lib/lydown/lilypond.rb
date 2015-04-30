require 'lydown/errors'

module Lydown
  module Lilypond
    class << self
      def compile(source, opts = {})
        # Run lilypond, pipe source into its STDIN, and capture its STDERR
        cmd = 'lilypond -lERROR '
        cmd << (opts[:path] ? "-o #{opts[:path]} " : '-o lydown ')
        cmd << "--#{opts[:format]} " if opts[:format]
        cmd << '-s - 2>&1'
        
        err_info = ''
        IO.popen(cmd, 'r+') do |f|
          f.puts source
          f.close_write
          err_info = f.read
          f.close
        end
        unless $?.success?
          err_info = err_info.lines[0, 3].join
          raise LydownError, "Lilypond compilation failed:\n#{err_info}"
        end
      end
    end
  end
end

