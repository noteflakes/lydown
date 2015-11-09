require 'net/http'
require 'uri'
require 'ruby-progressbar'
require 'tempfile'
require 'fileutils'

module Lydown::CLI::Installer
  class << self
    def install(package, version = nil)
      case package
      when 'lilypond'
        Lilypond.install(version)
      else
        STDERR.puts "Unknown package name specified"
        exit!(1)
      end
    end
  end
  
  module Lilypond
    class << self
      LILYPOND_DEFAULT_VERSION = "2.19.29"
      
      def detect_version(specified_version)
        case specified_version
        when nil, 'stable'
          list = get_version_list
        end
      end
    
      def install(version = nil)
        platform = detect_lilypond_platform
        version ||= LILYPOND_DEFAULT_VERSION
        # version = detect_version(version)
        url = lilypond_install_url(platform, version)
        fn = Tempfile.new('lydown-lilypond-installer').path

        download_lilypond(url, fn)
        install_lilypond_files(fn, platform, version)
      rescue => e
        STDERR.puts "Failed to install lilypond #{version}"
        puts e.message
        puts e.backtrace.join("\n")
        exit(1)
      end
    
      BASE_URL = "http://download.linuxaudio.org/lilypond/binaries"
    
      def lilypond_install_url(platform, version)
        ext = platform =~ /darwin/ ? ".tar.bz2" : ".sh"
        filename = "lilypond-#{version}-1.#{platform}"
      
        "#{BASE_URL}/#{platform}/#{filename}#{ext}"
      end
    
      def detect_lilypond_platform
        case RUBY_PLATFORM
        when /x86_64-darwin/
          "darwin-x86"
        when /ppc-darwin/
          "darwin-ppc"
        when "i686-linux"
          "linux-x86"
        when "x86_64-linux"
          "linux-64"
        when "ppc-linux"
          "linux-ppc"
        end
      end
    
      def download_lilypond(url, fn)
        STDERR.puts "Downloading #{url}"
      
        url_base = url.split('/')[2]
        url_path = '/'+url.split('/')[3..-1].join('/')
        download_count = 0

        Net::HTTP.start(url_base) do |http|
          request_url = URI.escape(url_path)
          response = http.request_head(request_url)
          total_size = response['content-length'].to_i
          pbar = ProgressBar.create(title: 'Downloading', total: total_size)
          File.open(fn, 'w') do |f|
            http.get(request_url) do |data|
              f << data
              download_count += data.length 
              pbar.progress = download_count if download_count <= total_size
            end
          end
          pbar.finish
        end
      end
    
      def install_lilypond_files(fn, platform, version)
        case platform
        when /darwin/
          install_lilypond_files_osx(fn, version)
        when /linux/
          install_lilypond_files_linux(fn, version)
        end
      end
    
      def install_lilypond_files_osx(fn, version)
        target = "/tmp/lydown/installer/lilypond"
        FileUtils.mkdir_p(target)
      
        STDERR.puts "Extracting..."
        exec "tar -xjf #{fn} -C #{target}"
      
        copy_lilypond_files("#{target}/LilyPond.app/Contents/Resources", version)
      end
    
      def install_lilypond_files_linux(fn, version)
        target = "/tmp/lydown/installer/lilypond"
        FileUtils.mkdir_p(target)
      
        # create temp directory in which to untar file
        tmp_dir = "/tmp/lydown/#{Time.now.to_f}"
        FileUtils.mkdir_p(tmp_dir)
      
        FileUtils.cd(tmp_dir) do
          exec "sh #{fn} --tarball"
        end
      
        STDERR.puts "Extracting..."
        exec "tar -xjf #{tmp_dir}/#{fn} -C #{target}"
      
        copy_lilypond_files_linux("#{target}/usr", version)
      end

      def copy_lilypond_files(base_path, version)
        target_dir = File.expand_path("~/.lydown/packages/lilypond/#{version}")
        
        FileUtils.rm_rf(target_dir) if File.exists?(target_dir)
        
        # create directory for lilypond files
        FileUtils.mkdir_p(target_dir)
      
        # copy files
        STDERR.puts "Copying..."
        %w{bin etc lib lib64 share var}.each do |entry|
          dir = File.join(base_path, entry)
          FileUtils.cp_r(dir, target_dir, remove_destination: true) if File.directory?(dir)
        end
        
        install_lilypond_executable(base_path, version)
      end
      
      BIN_SCRIPT_PATH = "#{File.expand_path('~')}/bin/lilypond"
      
      def install_lilypond_executable(base_path, version)
        target_dir = File.expand_path("~/.lydown/packages/lilypond/#{version}")

        script = "#!/bin/sh\n#{target_dir}/bin/lilypond \"$@\"\n"
        
        # create executable
        FileUtils.rm(BIN_SCRIPT_PATH) if File.file?(BIN_SCRIPT_PATH)
        File.open(BIN_SCRIPT_PATH, 'w+') {|f| f << script}
        FileUtils.chmod('+x', BIN_SCRIPT_PATH)
        # symlink_path = File.expand_path('~/bin/lilypond')
        # FileUtils.ln_sf("#{target_dir}/bin/lilypond", symlink_path)
        
        test_lilypond
      end
      
      def test_lilypond
        STDERR.puts `lilypond -v`
      end
      
      def exec(cmd)
        raise unless system(cmd)
      end
    end
  end
end
