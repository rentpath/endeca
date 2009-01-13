require File.join(File.dirname(__FILE__), %w[.. spec_helper])

describe Endeca::Document do
  before do
    Endeca::Document.path 'http://endeca.example.com'
    @document = Endeca::Document.new
  end

  describe ".by_id" do
    it "should make a request with the correct query to find by id" do
      Endeca::Request.
        should_receive(:perform).
        with('http://endeca.example.com', {'R' => '1234'})

      Endeca::Document.by_id('1234')
    end

    it "should instantiate a new Endeca::Document from the response hash" do
      hash = {:response => :hash}
      Endeca::Request.stub!(:perform).and_return(hash)
      Endeca::Document.should_receive(:new).with(hash)
      Endeca::Document.by_id('1234')
    end
  end
end
