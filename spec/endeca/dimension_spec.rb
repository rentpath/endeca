require File.join(File.dirname(__FILE__), %w[.. spec_helper])

describe Endeca::Dimension do
  describe ".new" do
    it "should set the raw attribute" do
      dimension = Endeca::Dimension.new(:raw)

      dimension.raw.should == :raw
    end
  end
  
  describe "#to_endeca_params" do
    before do
      @dimension = Endeca::Dimension.new
      @selection = mock('selection link')
      @removal = mock('removal link')
    end

    describe "with a selection link" do
      it "should return the selection link" do
        @dimension.stub!(:selection_link => @selection_link)
        @dimension.stub!(:removal_link => nil)
        
        @dimension.to_endeca_params.should == @selection_link
      end
    end
    
    describe "with a removal link" do
      it "should return the selection link" do
        @dimension.stub!(:selection_link => nil)
        @dimension.stub!(:removal_link => @removal_link)
        
        @dimension.to_endeca_params.should == @removal_link
      end
    end
  end

  describe "#inspect" do
    before do
      @dimension = Endeca::Dimension.new
    end

    it "should include the class" do
      @dimension.inspect.should include(Endeca::Dimension.name)
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
      dim_1 = Endeca::Dimension.new
      dim_2 = Endeca::Dimension.new
      dim_2.stub!(:id).and_return(dim_1.id)

      (dim_1 == dim_2).should be_true
    end
  end

  describe "#<=>" do
    it "should compare names" do
      name = mock('name')

      dim_1 = Endeca::Dimension.new
      dim_2 = Endeca::Dimension.new

      dim_1.stub!(:name).and_return(name)
      dim_2.stub!(:name).and_return(name)

      name.should_receive(:<=>).with(name)

      dim_1 <=> dim_2
    end
  end
end
