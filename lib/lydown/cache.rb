require 'digest/md5'
require 'fileutils'

module Cache
  class << self
    def disable!
      @disabled = true
    end
    
    def enable!
      @disabled = false
    end
    
    def hit(*params)
      return yield if @disabled
      
      cache_key = calculate_hash(*params)
      if result = get(cache_key)
        result
      else
        result = yield
        set(cache_key, result)
        result
      end
    end
    
    def calculate_hash(*params)
      params.map do |p|
        Digest::MD5.hexdigest(p.is_a?(String) ? p : p.to_s)
      end.join('-')
    end
      
    def get(cache_key)
      fn = filename(cache_key)
      if File.file?(fn)
        Marshal.load(IO.read(fn))
      else
        nil
      end
    rescue
      nil
    end
    
    def set(cache_key, value)
      File.open(filename(cache_key), 'w+') do |f|
        f << Marshal.dump(value)
      end
    end
    
    CACHE_DIR = "/tmp/lydown/cache"
    FileUtils.mkdir_p(CACHE_DIR)
    
    def filename(cache_key)
      "#{CACHE_DIR}/#{cache_key}"
    end
  end
end