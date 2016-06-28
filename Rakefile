# For Bundler.with_clean_env
require 'bundler/setup'
require File.expand_path("./lib/lydown/version", File.dirname(__FILE__))

PACKAGE_NAME = "lydown"
VERSION = Lydown::VERSION
TRAVELING_RUBY_VERSION = "20150715-2.2.2"
ESCAPE_UTILS_VERSION = "1.0.1"

TRAVELING_RUBY_BASE_URL = "http://d6r77u77i8pq3.cloudfront.net/releases"
PACKAGING_BASE_PATH = "packaging/traveling-ruby"

desc "Package your app"
task :package => ['package:linux:x86', 'package:linux:x86_64', 'package:osx']

namespace :package do
  namespace :linux do
    desc "Package your app for Linux x86"
    task :x86 => [:bundle_install, 
      "#{PACKAGING_BASE_PATH}-#{TRAVELING_RUBY_VERSION}-linux-x86.tar.gz",
      "#{PACKAGING_BASE_PATH}-#{TRAVELING_RUBY_VERSION}-linux-x86-escape_utils-#{ESCAPE_UTILS_VERSION}.tar.gz"
    ] do
      create_package("linux-x86")
    end

    desc "Package your app for Linux x86_64"
    task :x86_64 => [:bundle_install, 
      "#{PACKAGING_BASE_PATH}-#{TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz",
      "#{PACKAGING_BASE_PATH}-#{TRAVELING_RUBY_VERSION}-linux-x86_64-escape_utils-#{ESCAPE_UTILS_VERSION}.tar.gz"
    ] do
      create_package("linux-x86_64")
    end
  end

  desc "Package your app for OS X"
  task :osx => [:bundle_install, 
    "#{PACKAGING_BASE_PATH}-#{TRAVELING_RUBY_VERSION}-osx.tar.gz",
    "#{PACKAGING_BASE_PATH}-#{TRAVELING_RUBY_VERSION}-osx-escape_utils-#{ESCAPE_UTILS_VERSION}.tar.gz"
  ] do
    create_package("osx")
  end

  desc "Install gems to local directory"
  task :bundle_install do
    if RUBY_VERSION !~ /^2\.2\./
      abort "You can only 'bundle install' using Ruby 2.2, because that's what Traveling Ruby uses."
    end
    sh "rm -rf packaging/tmp"
    sh "mkdir packaging/tmp"
    sh "cp Gemfile Gemfile.lock packaging/tmp/"
    Bundler.with_clean_env do
      sh "cd packaging/tmp && env BUNDLE_IGNORE_CONFIG=1 bundle install --path ../vendor --without spec"
    end
    sh "rm -rf packaging/tmp"
    sh "rm -f packaging/vendor/*/*/cache/*"
    sh "rm -rf packaging/vendor/ruby/*/extensions"
    sh "find packaging/vendor/ruby/*/gems -name '*.so' | xargs rm -f"
    sh "find packaging/vendor/ruby/*/gems -name '*.bundle' | xargs rm -f"
    sh "find packaging/vendor/ruby/*/gems -name '*.o' | xargs rm -f"
  end
end

file "#{PACKAGING_BASE_PATH}-#{TRAVELING_RUBY_VERSION}-linux-x86.tar.gz" do
  download_runtime("linux-x86")
end

file "#{PACKAGING_BASE_PATH}-#{TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz" do
  download_runtime("linux-x86_64")
end

file "#{PACKAGING_BASE_PATH}-#{TRAVELING_RUBY_VERSION}-osx.tar.gz" do
  download_runtime("osx")
end

file "#{PACKAGING_BASE_PATH}-#{TRAVELING_RUBY_VERSION}-linux-x86-escape_utils-#{ESCAPE_UTILS_VERSION}.tar.gz" do
  download_native_extension("linux-x86", "escape_utils-#{ESCAPE_UTILS_VERSION}")
end

file "#{PACKAGING_BASE_PATH}-#{TRAVELING_RUBY_VERSION}-linux-x86_64-escape_utils-#{ESCAPE_UTILS_VERSION}.tar.gz" do
  download_native_extension("linux-x86_64", "escape_utils-#{ESCAPE_UTILS_VERSION}")
end

file "#{PACKAGING_BASE_PATH}-#{TRAVELING_RUBY_VERSION}-osx-escape_utils-#{ESCAPE_UTILS_VERSION}.tar.gz" do
  download_native_extension("osx", "escape_utils-#{ESCAPE_UTILS_VERSION}")
end

def create_package(target)
  package_path = "#{PACKAGE_NAME}-#{VERSION}-#{target}"
  sh "rm -rf #{package_path}"
  sh "mkdir #{package_path}"
  sh "mkdir -p #{package_path}/lib/app"
  sh "cp -r bin #{package_path}/lib/app/"
  sh "cp -r lib #{package_path}/lib/app/"
  sh "mkdir #{package_path}/lib/ruby"
  sh "tar -xzf #{PACKAGING_BASE_PATH}-#{TRAVELING_RUBY_VERSION}-#{target}.tar.gz -C #{package_path}/lib/ruby"
  sh "cp packaging/wrapper.sh #{package_path}/lydown"
  sh "cp -pR packaging/vendor #{package_path}/lib/"
  sh "cp Gemfile Gemfile.lock #{package_path}/lib/vendor/"
  sh "mkdir #{package_path}/lib/vendor/.bundle"
  sh "cp packaging/bundler-config #{package_path}/lib/vendor/.bundle/config"
  sh "tar -xzf #{PACKAGING_BASE_PATH}-#{TRAVELING_RUBY_VERSION}-#{target}-escape_utils-#{ESCAPE_UTILS_VERSION}.tar.gz " +
      "-C #{package_path}/lib/vendor/ruby"
  if !ENV['DIR_ONLY']
    sh "mkdir -p releases"
    sh "tar -czf releases/#{package_path}.tar.gz #{package_path}"
    sh "rm -rf #{package_path}"
  end
end

def download_runtime(target)
  sh "cd packaging && curl -L -O --fail " +
    "#{TRAVELING_RUBY_BASE_URL}/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}.tar.gz"
end

def download_native_extension(target, gem_name_and_version)
  sh "curl -L --fail -o packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}-#{gem_name_and_version}.tar.gz " +
    "#{TRAVELING_RUBY_BASE_URL}/traveling-ruby-gems-#{TRAVELING_RUBY_VERSION}-#{target}/#{gem_name_and_version}.tar.gz"
end






desc "Push gem to rubygems.org"
task :push_gem do
  sh "gem build lydown.gemspec"
  sh "gem push lydown-#{VERSION}.gem"
  sh "rm *.gem"
end

desc "Install gem locally"
task :install_gem do
  sh "gem uninstall -a -x --force lydown"
  sh "gem build lydown.gemspec"
  sh "gem install lydown-#{VERSION}.gem"
  sh "rm lydown-#{VERSION}.gem"
end

