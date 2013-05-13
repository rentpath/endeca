require 'spec_helper'

describe Endeca::Transformer do
  class Helper
    extend Endeca::Transformer

    inherited_accessor :mappings, {}
  end

  before do
    @helper = Helper.new
  end

  it "should add the map method to the class" do
    Helper.should respond_to(:map)
  end

  it "should add the tranform_query_options method to the class" do
    Helper.should respond_to(:transform_query_options)
  end

  describe ".map" do
    it "should raise Argument error for more than one key=>value pair" do
      lambda{Helper.map({:foo => :bar, :bizz => :bazz})}.
        should raise_error(ArgumentError, "map only accepts one key=>value pair")
    end

    it "should add Map object to mappings" do
      Helper.map :foo => :bar
      Helper.mappings[:foo].class.should == Endeca::Map 
    end

    it "should add Map object to mappings with only one argument" do
      Helper.map :foo
      Helper.mappings[:foo].class.should == Endeca::Map 
    end

    it "should create a boolean mapping" do
      Helper.map(:foo => :bar).should be_boolean
    end
  end

  describe ".transform_query_options" do
    it "should return new query based on transformation" do
      Helper.map :foo => :bar
      expected_query = {:bar  => :bazz}
      Helper.transform_query_options(:foo => :bazz).should == expected_query
    end
  end
end
