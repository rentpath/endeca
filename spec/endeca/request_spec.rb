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
    
    it "should not make more than one request" do
      @request.should_receive(:handle_response).exactly(1).times.and_return({})
      @request.perform
    end    

    describe "when successful" do
      before do
        @response_json = "{\"foo\":\"bar\"}"
        @response_hash = {"foo" => "bar"}
        @curl_obj = mock(:body_str => @response_json)
        Curl::Easy.stub!(:perform).and_return(@curl_obj)
      end

      it "should return the parsed JSON of the response body" do
        @request.perform.should == @response_hash
      end
    
      it "should not raise an error" do
        lambda { @request.perform }.should_not raise_error
      end
    end
    
    describe "when unsuccessful" do
      before do
        @curl_obj = mock(:response_code => 404)
        Curl::Easy.stub!(:perform).and_return(@curl_obj)
      end
      
      it "should raise an Endeca::RequestError" do
        lambda {@request.perform}.should raise_error(Endeca::RequestError, "404 HTTP Error")
      end
    
    end
    
    describe "Yajl parser" do
      it "should return Endeca::RequestError when malformed JSON is returned"
        @curl_obj = mock(:response_code => 200, :body_str => "!@!@#@SDSD}")
        Curl::Easy.stub!(:perform).and_return(@curl_obj)
        lambda {@request.perform}.should raise_error(Endeca::RequestError)
      end
    end
    
    describe "when the response contains an error hash" do
         before do
           @error_message = "com.endeca.soleng.urlformatter.QueryBuildException: com.endeca.navigation.UrlENEQueryParseException: java.lang.NumberFormatException: For input string: \"asdjkhfgasdfjkhg\""
           @error_response = {
             "methodResponse"=>
               {"fault"=>
                 {"value"=>
                   {"faultCode"=>"-1",
                    "faultString"=> @error_message}}}}
           @error_request = Endeca::Request.new(@path)
           @error_request.stub!(:handle_response).and_return(@error_response)
         end
         
         it "should raise an Endeca::RequestError" do
           lambda { @error_request.perform }.should raise_error(Endeca::RequestError, @error_message)
         end
       end

  describe '#uri' do
    
    describe "with a hash of query options" do
      
      it "should append the query options onto the url" do
        query = {:foo => :bar}
        Endeca::Request.new(@path, query).uri.query.should == query.to_endeca_params
      end
      
    end
    
  end

  describe "with a string of query options" do
    it "should append the query options string onto the url" do
      query = 'N=56'
      Endeca::Request.new(@path, query).uri.query.should == query.to_endeca_params
    end
  end
end
