require File.join(File.dirname(__FILE__), %w[.. spec_helper])

module Endeca
  module Breadcrumbs
    class Navigation < Endeca::Breadcrumb
    end
  end
end

describe Endeca::Breadcrumb do
  before do
    @dimension_value = {
      "DimValueID"   => "4343565665",
      "RemovalLink"  => "N=",
      "DimValueName" => "Apartment"
    }
    
    @navigation_hash = { 
      "Type"                 => "Navigation",
      "DimensionName"        => "property type", 
      "DimensionRemovalLink" => "N=", 
      "DimensionValues"      => [@dimension_value] 
    }

    @dimensions = { "Dimensions" => [@navigation_hash] }
    @breadcrumb = Endeca::Breadcrumb.new( @dimensions )
  end
  
  describe ".create" do
    before do
      @navigation = Endeca::Breadcrumb.create(@navigation_hash)
    end
    
    it "should create a breadcrumb of the appropriate type" do
      Endeca::Breadcrumb.create(@navigation_hash).
        should be_a_kind_of(Endeca::Breadcrumbs::Navigation)
    end
    
    describe "with an invalid type" do
      it do
        creating_invalid_breadcrumb = lambda{Endeca::Breadcrumb.create({'Type' => 'Invalid'})}
        creating_invalid_breadcrumb.should raise_error(Endeca::Breadcrumbs::TypeError)
      end
    end
  end
  
  describe '#==' do
    it "should compare Breadcrumbs by name" do
      doc_1, doc_2 = Endeca::Breadcrumb.new, Endeca::Breadcrumb.new
      doc_1.stub!(:name).and_return('property type')
      doc_2.stub!(:name).and_return('property type')
      (doc_1 == doc_2).should be_true

      doc_2.stub!(:name).and_return('something else')
      (doc_1 == doc_2).should be_false
    end
  end

  describe '#inspect' do
    it "includes the class name" do
      @breadcrumb.inspect.should include(Endeca::Breadcrumb.name)
    end

    it "includes the hex string of the object id" do
      @breadcrumb.inspect.should include("0x#{@breadcrumb.object_id.to_s(16)}")
    end

    it "includes the inspected name" do
      @breadcrumb.stub!(:name).and_return('A Name')
      @breadcrumb.inspect.should include('name="A Name"')
    end
  end
  
  describe "#type" do
    it "returns the Type value" do
      Endeca::Breadcrumb.new('Type' => 'AType').type.should == 'AType'
    end
  end
  
  describe "#name" do
    it {Endeca::Breadcrumb.new.name.should == ''}
  end
end
