require File.join(File.dirname(__FILE__), %w[.. spec_helper])

describe Endeca::Map do
  before do
    @query = {:foo => "bazz"}
    @map = Endeca::Map.new :foo, :bizz
  end

  describe ".perform" do
    it "should return correctly mapped hash" do
      @map.perform(@query).should == [:bizz ,"bazz"]
    end

    it "should nest in parent_hash" do
      @map.in({:bip => :bop}).perform(@query).
        should == [{:bip => :bizz}, {:bop => "bazz"}]
    end

    it "should transform the value based on the block" do
      map = @map.transform{|val| val.upcase}
      map.perform(@query).should == [:bizz, "BAZZ"]
    end
  end
end
