require 'spec_helper'

describe Endeca::Refinement do
  before do
    @dimension_value = {
      "DimValueID" => "4294965335",
      "SelectionLink" => "N=4294965335&Ne=3",
      "DimValueName" => "Winter Park",
      "NumberofRecords" => "44"
    }

    dimensions = { "Dimensions" => [ 
      { 
        "DimensionID" => "3",
        "DimensionName" => "state", 
        "ContractionLink" => "N=",
        "DimensionValues" => [@dimension_value] 
      }
     ]
    }
    @refinement = Endeca::Refinement.new( dimensions )
  end

  describe '#==' do
    it "should compare refinements by id" do
      doc_1, doc_2 = Endeca::Refinement.new, Endeca::Refinement.new
      doc_1.stub!(:id).and_return(1)
      doc_2.stub!(:id).and_return(1)
      (doc_1 == doc_2).should be_true

      doc_2.stub!(:id).and_return(2)
      (doc_1 == doc_2).should be_false
    end
  end

  describe '#inspect' do
    it "includes the class name" do
      @refinement.inspect.should include(Endeca::Refinement.name)
    end

    it "includes the hex string of the object id" do
      @refinement.inspect.should include("0x#{@refinement.object_id.to_s(16)}")
    end

    it "includes the id" do
      @refinement.stub!(:id).and_return(1)
      @refinement.inspect.should include('id=1')
    end

    it "includes the inspected name" do
      @refinement.stub!(:name).and_return('A Name')
      @refinement.inspect.should include('name="A Name"')
    end
  end

  it "should return to_endeca_params on the contraction link " do
    @refinement.to_endeca_params.should == "N="
  end

  it "should return an array of dimensions for dimension_values" do
    my_dimension = Endeca::Dimension.new(@dimension_value)
    @refinement.dimension_values.should == [my_dimension]
  end

  it "should return an array of dimensions" do
    refinement_dim_raw = mock("raw dimension refinement")
    refinement_dim = mock(Endeca::RefinementDimension)
    @refinement.attributes['Dimensions'] = [refinement_dim_raw]
    Endeca::RefinementDimension.should_receive(:new).with(refinement_dim_raw).and_return(refinement_dim)
    @refinement.dimensions.should == [refinement_dim]
  end
end
