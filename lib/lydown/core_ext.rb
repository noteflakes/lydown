class Hash
  # Merges self with another hash, recursively.
  #
  # This code was lovingly stolen from some random gem:
  # http://gemjack.com/gems/tartan-0.1.1/classes/Hash.html
  #
  # Thanks to whoever made it.
  def deep_merge(hash)
    target = Marshal.load(Marshal.dump(self))
    target.deep_merge!(hash)
  end

  def deep_merge!(hash)
    hash.keys.each do |key|
      if hash[key].is_a? Hash and self[key].is_a? Hash
        self[key] = self[key].deep_merge!(hash[key])
        next
      end

      self[key] = hash[key]
    end

    self.deep = true
    self
  end

  def lookup(path)
    path.split("/").inject(self) {|m,i| m[i].nil? ? (return nil) : m[i]}
  end
  
  def set(path, value)
    leafs = path.split("/")
    k = leafs.pop
    h = leafs.inject(self) {|m, i| m[i].is_a?(Hash) ? m[i] : (m[i] = {})}
    h[k] = value
  end
  
  attr_accessor :deep

  alias_method :old_get, :[]
  def [](k)
    if @deep && k.is_a?(String) && k =~ /\//
      lookup(k)
    elsif @deep && k.is_a?(Symbol)
      old_get(k.to_s)
    else
      old_get(k)
    end
  end
  
  alias_method :old_set, :[]=
  def []=(k, v)
    if @deep && k.is_a?(String) && k =~ /\//
      set(k, v)
    elsif @deep && k.is_a?(Symbol)
      old_set(k.to_s, v)
    else
      old_set(k, v)
    end
  end
  
  alias_method :old_merge, :merge
  def merge(hash)
    if deep || hash.deep
      deep_merge(hash)
    else
      old_merge(hash)
    end
  end
  
  alias_method :old_merge!, :merge!
  def merge!(hash)
    if deep || hash.deep
      deep_merge!(hash)
    else
      old_merge!(hash)
    end
  end
end

