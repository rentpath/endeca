require File.join(File.dirname(__FILE__), %w[.. spec_helper])

describe Endeca::DocumentCollection do
  before do
    @metainfo = mock('MetaInfo', :[] => nil)
    @document = mock('Document', :[] => nil)
    @refinement = { "Dimensions" => [ {
                                "ExpansionLink" =>  "N=&Ne=7",
                                "DimensionName" => "city",
                                "DimensionID"  => "7" } ] }

    @raw = {
      'Records'     => [@document],
      'MetaInfo'    => @metainfo,
      'Refinements' => [@refinement]
    }
    @document_collection = Endeca::DocumentCollection.new(@raw)
  end

  describe '#new' do
    it "should store the raw data" do
      @document_collection.raw.should == @raw
    end
  end

  describe '#attributes' do
    it "should return the metainfo hash of the collection" do
      @document_collection.attributes.should == @metainfo
    end
  end

  describe '#documents' do
    it "should return a collection of documents" do
      @document_collection.documents.size.should == 1
      @document_collection.documents.first.should == Endeca::Document.new(@document)
    end

    it "should return the correct document class for subclassees" do
      class ConcreteDocument < Endeca::Document; end
      collection = Endeca::DocumentCollection.new(@raw, ConcreteDocument)
      collection.documents.first.class.should == ConcreteDocument
    end
  end

  describe "#previous_page" do
    describe "when on the first page" do
      before do
        @document_collection.stub!(:current_page).and_return(0)
      end

      it "should be nil" do
        @document_collection.previous_page.should be_nil
      end
    end

    describe "when on any other page" do
      before do
        @document_collection.stub!(:current_page).and_return(4)
      end

      it "should return the previous page" do
        @document_collection.previous_page.should == 3
      end
    end
  end

  describe "#next_page" do
    before do
      @document_collection.stub!(:total_pages).and_return(20)
    end

    describe "when on the last page" do
      before do
        @document_collection.stub!(:current_page).and_return(20)
      end

      it "should be nil" do
        @document_collection.next_page.should be_nil
      end
    end

    describe "when on any other page" do
      before do
        @document_collection.stub!(:current_page).and_return(4)
      end

      it "should return the next page" do
        @document_collection.next_page.should == 5
      end
    end
  end

  describe '#refinements' do
    it 'should return a collection of Refinement objects' do
      @document_collection.refinements.should == [Endeca::Refinement.new(@refinement)]
    end

    it "should return refinement uri by name" do
      @document_collection.refinement_uri_by_name('city').should == "N=&Ne=7"
    end
  end

  describe "#each" do
    it "should yield to the documents" do
      block = lambda{1}
      @document_collection.documents.should_receive(:each).with(&block)
      @document_collection.each(&block)
    end
  end

  describe "#is_a?" do
    it "should be true if the compared class is Array" do
      @document_collection.is_a?(Array).should be_true
    end

    it "should be true if the compared class is Endeca::DocumentCollection" do
      @document_collection.is_a?(Endeca::DocumentCollection).should be_true
    end

    it "should be false if the compared class is String" do
      @document_collection.is_a?(String).should be_false
    end
  end
end
