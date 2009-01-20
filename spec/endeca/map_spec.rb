require File.join(File.dirname(__FILE__), %w[.. spec_helper])

describe Endeca::Map do
  before do
    @query = {:foo => "bazz", :bizz => "somevalue"}
    @map = Endeca::Map.new :foo, :bizz
  end

  describe ".perform" do
    it "should return correctly mapped hash" do
      @map.perform(@query).should == {:bizz => "bazz"}
    end

    it "should transform the value based on the block" do
      map = @map.transform{|val| val.to_s.upcase}
      map.perform(@query).should == {:bizz => "BAZZ"}
    end

    it "should nest in parent_hash" do
      @map.into({:bip => :bop}).perform(@query).
        should == {:bip => "bizz", :bop => "bazz"}
    end

    it "should join the new value with the existing value" do
      map = @map.join('|')
      map.perform(@query).should == {:bizz => "somevalue|bazz"}
    end
  end

  describe "#boolean" do
    it "should convert a true value to its integral equivalent" do
      @map.boolean.perform(:foo => true).should == {:bizz => 1}
    end

    it "should convert a false value to its integral equivalent" do
      @map.boolean.perform(:foo => false).should == {:bizz => 0}
    end
  end
end
