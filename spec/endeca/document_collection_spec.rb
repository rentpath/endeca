require File.join(File.dirname(__FILE__), %w[.. spec_helper])

describe Endeca::DocumentCollection do
  before do
    @metainfo = mock('MetaInfo', :[] => nil)
    @document = mock('Document', :[] => nil)
    @refinement = mock('Refinement', :[] => [])
    @raw = {
      'Records' => [@document],
      'MetaInfo' => @metainfo,
      'Refinements' => [@refinement]
    }
    @document_collection = Endeca::DocumentCollection.new(@raw)
  end

  describe '#new' do

    it "should store the raw data" do
      @document_collection.raw.should == @raw
    end
  end

  describe '#documents' do
    it "should return a collection of documents" do
      @document_collection.documents.size.should == 1
      @document_collection.documents.first.should == Endeca::Document.new(@document)
    end

    it "should return the correct document class for subclassees" do
      class ConcreteDocument < Endeca::Document; end
      Endeca::DocumentCollection.new(@raw, ConcreteDocument).documents.first.class.should == ConcreteDocument
    end
  end

  describe '#attributes' do
    it "should return the metainfo hash of the collection" do
      @document_collection.attributes.should == @metainfo
    end
  end

  describe '#refinements' do
    it 'should return a collection of Refinement objects' do
      @document_collection.refinements.should == [Endeca::Refinement.new(@refinement)]
    end
  end

  describe "#each" do
    it "should yield to the documents" do
      block = lambda{1}
      @document_collection.documents.should_receive(:each).with(&block)
      @document_collection.each(&block)
    end
  end
end
