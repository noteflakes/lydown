require 'lydown/errors'
require 'tempfile'
require 'fileutils'

module Lydown
  module Lilypond
    class << self
      def tmpdir
        @tmpdir ||= Dir.mktmpdir
      end
      
      def compile(source, opts = {})
        opts[:output_filename] ||= 'lydown'
        
        target = opts[:output_filename].dup
        ext = ".#{opts[:format] || 'pdf'}"
        if target !~ /#{ext}$/
          target << ext
        end
        
        tmp_target = Tempfile.new('lydown').path
        opts[:output_filename] = tmp_target
        invoke(source, opts)
        FileUtils.cp(tmp_target + ext, target)
      rescue => e
        puts e.message
        p e.backtrace
      end
      
      def invoke(source, opts = {})
        # Run lilypond, pipe source into its STDIN, and capture its STDERR
        cmd = 'lilypond -lERROR '
        cmd << "-o #{opts[:output_filename]} "
        cmd << "--#{opts[:format]} " if opts[:format]
        cmd << '-s - 2>&1'
        # cmd << "-s #{ly_path} 2>&1"
        
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

