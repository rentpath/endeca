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

    it "should be indifferent to string or symbol keys" do
      @map.perform("foo" => "bazz").should == {:bizz => "bazz"}
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

  describe "#into" do
    it "should assign the hash to map the given query hash into" do
      @map.into(:foo => :bar).instance_variable_get(:@into).should == {:foo => :bar}
    end

    it "should assign the default character to join keys to values with" do
      @map.into(:foo => :bar).instance_variable_get(:@with).should == ':'
    end

    it "should assign the default character used to join key/value pairs" do
      @map.into(:foo => :bar).instance_variable_get(:@join).should == '|'
    end
  end

  describe "#perform_into" do
    describe "with an enclosing string" do
      it "wraps the parameter" do
        map = Endeca::Map.new(:foo, :bar)
        map.into(:bizz).enclose(:AND)
        map.perform(:foo => :quux).should == {:bizz => 'AND(bar:quux)'}
      end
    end

    describe "with replace" do
      it "replaces the existing parameter" do
        map = Endeca::Map.new(:foo, :bar)
        map.into(:bizz).replace!
        map.perform(:foo => :quux, :bizz => :foobar).should == {:bizz => 'bar:quux'}
      end
    end

    describe "with enclose and replace" do
      it "wraps the parameter and replaces the existing parameter" do
        map = Endeca::Map.new(:foo, :bar)
        map.into(:bizz).enclose(:AND).replace!
        map.perform(:foo => :quux, :bizz => :foobar).should == {:bizz => 'AND(bar:quux)'}
      end
    end
  end

  describe "#with" do
    it "should assign the character to join keys to values with" do
      @map.with('*').instance_variable_get(:@with).should == '*'
    end
  end

  describe "#join" do
    it "should assign the character used to join key/value pairs" do
      @map.join('*').instance_variable_get(:@join).should == '*'
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

  describe "#==" do
    it "is true if the keys, join and transformations are equivalent" do
      Endeca::Map.new(:foo, :bar).into(:M).should == Endeca::Map.new(:foo, :bar).into(:M)
    end
  end

  describe "#transform" do
    it "should execute the transformation block on the query"
      map = Endeca::Map.new(:field_list)
      map.into(:F).transform do |fields_array|
        fields_array.collect{|field| "#{field.to_s}:1"}.join('|')
      map.perform(:field_list => [:first_name, :last_name, :email]).
        should == {:F => "first_name:1|last_name:1|email:1"}
    end
  end
end
