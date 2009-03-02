require File.dirname(__FILE__) + '/../spec_helper'

describe Endeca::RefinementDimension do
  describe ".new" do
    it "should set the raw attribute" do
      dimension = Endeca::RefinementDimension.new(:raw)

      dimension.raw.should == :raw
    end
  end
  
  describe "#to_endeca_params" do
    before do
      @dimension = Endeca::RefinementDimension.new("ExpansionLink" => "expansion link")
    end
    
    it() {@dimension.to_endeca_params.should == "expansion link"}

  end

  describe "#inspect" do
    before do
      @dimension = Endeca::RefinementDimension.new
    end

    it "should include the class" do
      @dimension.inspect.should include(Endeca::RefinementDimension.name)
    end

    it "should include the hex formatted object_id" do
      id = 123
      @dimension.stub!(:object_id).and_return(id)
      @dimension.inspect.should include("0x#{id.to_s(16)}")
    end

    it "should include the id" do
      id = 123
      @dimension.stub!(:id).and_return(id)
      @dimension.inspect.should include("id=#{id}")
    end

    it "should include the inspected name" do
      name = 'name'
      @dimension.stub!(:name).and_return(name)
      @dimension.inspect.should include("name=#{name.inspect}")
    end
  end

  describe "#==" do
    it "should compare ids" do
      dim_1 = Endeca::RefinementDimension.new
      dim_2 = Endeca::RefinementDimension.new
      dim_2.stub!(:id).and_return(dim_1.id)

      (dim_1 == dim_2).should be_true
    end
  end

  describe "#<=>" do
    it "should compare names" do
      name = mock('name')

      dim_1 = Endeca::RefinementDimension.new
      dim_2 = Endeca::RefinementDimension.new

      dim_1.stub!(:name).and_return(name)
      dim_2.stub!(:name).and_return(name)

      name.should_receive(:<=>).with(name)

      dim_1 <=> dim_2
    end
  end
end
