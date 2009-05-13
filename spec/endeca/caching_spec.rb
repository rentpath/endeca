require File.join(File.dirname(__FILE__), %w[.. spec_helper])

describe Endeca::Request do
  before(:all) do 
    Endeca.cache_store = :memory_store
  end

  after(:all) do 
    Endeca.disable_caching
  end

  before do
    @path     = "http://example.com"
    @query    = "foo=bar"
    @request  = Endeca::Request.new(@path, @query)
    @response = {"a successful" => "response"}

    @request.stub!(:handle_response).and_return(@response)
    @cache_key = :key
    @request.stub!(:cache_key).and_return(@cache_key)
  end

  describe "When a cached response is available" do
    before do
      Endeca.cache_store.write(@cache_key, @response)
    end

    it "should not perform the request" do
      @request.should_not_receive(:get_response_without_caching)
      @request.perform
    end

    it "should read from the cache" do
      @request.perform.should == @response
    end
  end

  describe "When a cached response is not available" do
    before do
      Endeca.cache_store.delete(@cache_key)
    end

    it "should perform the request" do
      @request.should_receive(:get_response_without_caching)
      @request.perform
    end

    it "should cache the response using the caching key" do
      @request.stub!(:get_response_without_caching).and_return(@response)

      @request.perform
      Endeca.cache_store.read(@request.send(:cache_key)).should == @response
    end
  end
end


describe Endeca::Caching do
  it "should return false when cache store is not set" do
    Endeca.perform_caching?.should be_false
  end

  it "should return false when if disable_caching has been set" do
    Endeca.cache_store = :memory_store
    Endeca.disable_caching
    Endeca.perform_caching?.should be_false
  end

  it "should return memory store" do
    Endeca.cache_store = :memory_store
    Endeca.cache_store.class.should == ActiveSupport::Cache::MemoryStore
  end
end
