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
        install_lilypond(version)
      else
        STDERR.puts "Unknown package name specified"
        exit!(1)
      end
    end
    
    LILYPOND_DEFAULT_VERSION = "2.19.29"
    
    def install_lilypond(version = nil)
      version ||= LILYPOND_DEFAULT_VERSION      
      platform = detect_lilypond_platform
      url = lilypond_install_url(platform, version)
      fn = Tempfile.new('lydown-lilypond-installer').path

      download_lilypond(url, fn)
      install_lilypond_files(fn, platform, version)
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
      @counter = 0

      Net::HTTP.start(url_base) do |http|
        response = http.request_head(URI.escape(url_path))
        pbar = ProgressBar.create(total: response['content-length'].to_i)
        File.open(fn, 'w') {|f|
          http.get(URI.escape(url_path)) do |str|
            f.write str
        @counter += str.length 
        pbar.progress = @counter
          end
         }
        pbar.finish
      end
    end
    
    def install_lilypond_files(fn, platform, version)
      case platform
      when /darwin/
        install_lilypond_files_osx(fn, version)
      end
    end
    
    def install_lilypond_files_osx(fn, version)
      target = "/tmp/lydown/installer/lilypond"
      `mkdir -p #{target}`
      
      STDERR.puts "Extracting..."
      `tar -xjf #{fn} -C #{target}`
      
      copy_lilypond_files_osx(target, version)
    end

    def copy_lilypond_files_osx(archive, version)
      base_path = "#{archive}/LilyPond.app/Contents/Resources"
      
      target_dir = File.expand_path("~/.lydown/packages/lilypond/#{version}")
      
      # create directory for lilypond files
      `mkdir -p #{target_dir}`
      
      # copy files
      %w{bin etc lib share}.each do |entry|
        `cp -R #{File.join(base_path, entry)} #{target_dir}`
      end
      
      # create symlink
      symlink_path = File.expand_path('~/bin/lilypond')
      `ln -Ffs #{target_dir}/bin/lilypond #{symlink_path}`
      
      STDERR.puts `lilypond -v`
    end
  end
end
