require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

RSpec.describe Cache do
  before(:all) do
    Cache.enable!
  end
  
  after(:all) do
    Cache.disable!
  end
  
  it "returns nil on cache miss" do
    key = "key#{rand(1_000_000)}"
    expect(Cache.get(key)).to be_nil
  end

  it "retrieves a value previously set" do
    key = "key#{rand(1_000_000)}"
    value = rand(1_000_000)
    
    Cache.set(key, value)
    
    expect(Cache.get(key)).to eq(value)
  end
end

RSpec.describe "Cache#hit" do
  before(:all) do
    Cache.enable!
  end
  
  after(:all) do
    Cache.disable!
  end

  it "calls supplied block on cache miss, and sets cache" do
    count = 0
    param = rand(1_000_000)
    value = {a: rand(1_000_000)}

    result = Cache.hit(param) do
      count += 1
      {b: value[:a] * 10}
    end
    
    expect(count).to eq(1)
    expect(result).to eq({b: value[:a] * 10})
    
    expect(Cache.get(Cache.calculate_hash(param))).to eq({b: value[:a] * 10})
  end
  
  it "does not call block on cache hit" do
    count = 0
    param = rand(1_000_000)
    value = rand(1_000_000)

    Cache.hit(param) do
      count += 1
      {c: value}
    end

    expect(count).to eq(1)

    result = Cache.hit(param) do
      count += 1
      {c: value}
    end

    expect(count).to eq(1)
    expect(result).to eq({c: value})
  end
end