require 'spec_helper'

describe Endeca::DocumentCollection do
  before do
    @metainfo = mock('MetaInfo', :[] => nil)
    @document = mock('Document', :[] => nil)
    @refinement = { "Dimensions" => [ {
                                "ExpansionLink" =>  "N=&Ne=7",
                                "DimensionName" => "city",
                                "DimensionID"  => "7" } ] }
    @breadcrumb = { "Dimensions" => [ {
                                "DimensionName" => "property type",
                                "DimensionRemovalLink" =>  "N=",
                                "Type"  => "Navigation" } ] }

    @raw = {
      'Records'     => [@document],
      'MetaInfo'    => @metainfo,
      'Refinements' => [@refinement],
      'Breadcrumbs' => [@breadcrumb]
    }

    @aggregate_raw = {
      'AggrRecords' => [{'Records' => [@document]}]
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
    it "should return the correct document class for subclassees" do
      class ConcreteDocument < Endeca::Document; end
      collection = Endeca::DocumentCollection.new(@raw, ConcreteDocument)
      collection.documents.first.class.should == ConcreteDocument
    end

    describe "with a normal record set" do
      it "should return a collection of documents" do
        @document_collection.documents.should == [Endeca::Document.new(@document)]
      end
    end

    describe "with an aggregate record set" do
      before do
        @document_collection = Endeca::DocumentCollection.new(@aggregate_raw)
      end

      it "should find the documents" do
        @document_collection.documents.size.should == 1
        @document_collection.documents.first.should == Endeca::Document.new(@document)
      end
    end

    describe "with no record set" do
      before { @document_collection = Endeca::DocumentCollection.new({}) }
      it { @document_collection.documents.should be_empty }
    end
  end

  describe "#aggregate?" do
    describe "with a normal document collection" do
      it { @document_collection.aggregate?.should be_false }
    end

    describe "with an aggregate document collection" do
      before { @document_collection = Endeca::DocumentCollection.new(@aggregate_raw) }
      it { @document_collection.aggregate?.should be_true }
    end
  end

  describe "#previous_page" do
    describe "when on the first page" do
      before { @document_collection.stub!(:current_page).and_return(0) }

      it { @document_collection.previous_page.should be_nil }
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
      before { @document_collection.stub!(:current_page).and_return(20) }
      it { @document_collection.next_page.should be_nil }
    end

    describe "when on any other page" do
      before { @document_collection.stub!(:current_page).and_return(4) }

      it "should return the next page" do
        @document_collection.next_page.should == 5
      end
    end
  end

  describe '#refinements' do
    it 'should return a collection of Refinement objects' do
      @document_collection.refinements.should == [Endeca::Refinement.new(@refinement)]
    end

    it "should return refinement by name" do
      @document_collection.refinement_by_name('city').
        should == Endeca::Refinement.new(@refinement)
    end
  end

  describe '#breadcrumbs' do
    it 'should return a collection of Breadcrumb objects' do
      @document_collection.breadcrumbs.should == [Endeca::Breadcrumb.new(@breadcrumb)]
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
    describe "Array" do
      it { @document_collection.is_a?(Array).should be_true }
    end

    describe "DocumentCollection" do
      it { @document_collection.is_a?(Endeca::DocumentCollection).should be_true }
    end

    describe "String" do
      it { @document_collection.is_a?(String).should be_false }
    end
  end
end
