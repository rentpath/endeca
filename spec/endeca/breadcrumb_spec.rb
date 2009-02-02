require File.join(File.dirname(__FILE__), %w[.. spec_helper])

describe Endeca::Breadcrumb do
  before do
    @dimension_value = {
      "DimValueID" => "4343565665",
      "RemovalLink" => "N=",
      "DimValueName" => "Apartment"
    }

    dimensions = { "Dimensions" => [ 
      { 
        "Type" => "Navigation",
        "DimensionName" => "property type", 
        "DimensionRemovalLink" => "N=", 
        "DimensionValues" => [@dimension_value] 
      }
     ]
    }
    @Breadcrumb = Endeca::Breadcrumb.new( dimensions )
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
      @Breadcrumb.inspect.should include(Endeca::Breadcrumb.name)
    end

    it "includes the hex string of the object id" do
      @Breadcrumb.inspect.should include("0x#{@Breadcrumb.object_id.to_s(16)}")
    end

    it "includes the inspected name" do
      @Breadcrumb.stub!(:name).and_return('A Name')
      @Breadcrumb.inspect.should include('name="A Name"')
    end
  end

  it "should return to_params on the dimension removal link " do
    @Breadcrumb.to_params.should == "N="
  end

  it "should return an array of dimensions for dimension_values" do
    my_dimension = Endeca::Dimension.new(@dimension_value)
    @Breadcrumb.dimension_values.should == [my_dimension]
  end
end
