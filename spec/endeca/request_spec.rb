require 'rubygems'
require 'fake_web'
require 'json'
require File.join(File.dirname(__FILE__), %w[.. spec_helper])

describe Endeca::Request do
  before do
    @path = 'http://example.com/foobar'
  end

  describe '.perform' do
    it "initalializes a new request object and performs the request" do
      path = 'path'
      query = 'query'
      request = mock('Endeca::Request')
      request.should_receive(:perform)
      Endeca::Request.should_receive(:new).with(path, query).and_return(request)

      Endeca::Request.perform(path, query)
    end
  end

  describe '#perform' do
    before do
      @request = Endeca::Request.new(@path)
    end

    describe "when successful" do
      before do
        @response_hash = {"foo" => "bar"}
        FakeWeb.register_uri(@path, :string => @response_hash.to_json)
      end

      it "should return the parsed JSON of the response body" do
        @request.perform.should == @response_hash
      end
    end

    describe "when unsuccessful" do
      before do
        FakeWeb.register_uri(@path, :status => ['404', 'Not Found'])
      end

      it "should raise an Endeca::RequestError" do
        lambda {@request.perform}.should raise_error(Endeca::RequestError, '404 "Not Found"')
      end

    end
  end

  describe '#uri'
    describe "with a hash of query options" do
      it "should append the query options onto the url" do
        query = {:foo => :bar}
        Endeca::Request.new(@path, query).uri.query.should == query.to_params
      end
    end

    describe "with a string of query options" do
      it "should append the query options string onto the url" do
        query = 'N=56'
        Endeca::Request.new(@path, query).uri.query.should == query.to_params
      end
    end
end
