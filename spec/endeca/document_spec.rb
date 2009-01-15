require File.join(File.dirname(__FILE__), %w[.. spec_helper])

describe Endeca::Document do
  before do
    Endeca::Document.path 'http://endeca.example.com'
    @document = Endeca::Document.new
  end

  describe '.find' do
    before do
      @query_options = {:foo => :bar}
    end

    describe '#==' do
      it "should compare documents by id" do
        id = 1
        doc_1 = Endeca::Document.new
        doc_1.stub!(:id).and_return(id)
        doc_2 = Endeca::Document.new
        doc_2.stub!(:id).and_return(id)

        (doc_1 == doc_2).should be_true

        doc_2.stub!(:id).and_return(2)

        (doc_1 == doc_2).should be_false
      end

    end
    describe 'with :first' do
      it 'should call .first and pass the query options' do
        Endeca::Document.should_receive(:first).with(@query_options)
        Endeca::Document.find(:first, @query_options)
      end
    end

    describe 'with :all' do 
      it "should call .all and pass the query options and self" do
        Endeca::Document.should_receive(:all).with(@query_options)
        Endeca::Document.find(:all, @query_options)
      end
    end

    describe 'with an Integer' do
      it "should call .by_id with the argument and the query options" do
        id = 5
        Endeca::Document.should_receive(:by_id).with(id, @query_options)
        Endeca::Document.find(id, @query_options)
      end
    end

    describe 'with an id string' do
      it "should call .by_id with the argument and the query options" do
        id = '5'
        Endeca::Document.should_receive(:by_id).with(id, @query_options)
        Endeca::Document.find(id, @query_options)
      end
    end

    describe 'with only query options' do
      it 'should call .all with the query options' do
        Endeca::Document.should_receive(:all).with(@query_options)
        Endeca::Document.find(@query_options)
      end
    end
  end

  describe ".first" do
    it "should make a request with the correct query" do
      Endeca::Request.
        should_receive(:perform).
        with('http://endeca.example.com', {:id => '1234'}).
        and_return({'Records' => []})

      Endeca::Document.first(:id => '1234')
    end

    it "should instantiate a new Endeca::Document from the first record in the response hash" do
      hash = {'Records' => [:document]}
      Endeca::Request.stub!(:perform).and_return(hash)
      Endeca::Document.
        should_receive(:new).
        with(:document)
      Endeca::Document.first(:id => '1234')
    end
  end

  describe '.by_id' do
    it 'should merge the id into the query options and call .first' do
      Endeca::Document.should_receive(:first).with(:id => '1234')
      Endeca::Document.by_id('1234')
    end
  end

  describe '.all' do
    before do
      @query_options = {:foo => :bar}
      @records = mock('RecordArray')
      @response = {'Records' => @records}
      Endeca::Document.
        stub!(:request).
        and_return(@response)
    end

    it 'should perform a request with the query options' do
      Endeca::Document.
        should_receive(:request).
        with(@query_options).
        and_return(@response)

      Endeca::Document.all(@query_options)
    end

    it 'should create a new DocumentCollection from the full response and the document class' do
      Endeca::DocumentCollection.should_receive(:new).with(@response, Endeca::Document)
      Endeca::Document.all(@query_options)
    end
  end
end
