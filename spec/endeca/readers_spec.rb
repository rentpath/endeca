require File.join(File.dirname(__FILE__), %w[.. spec_helper])

describe Endeca::Readers do
  class Helper
    extend Endeca::Readers
  end

  before do
    @helper = Class.new(Endeca::Document)
    @a_helper = @helper.new('Properties' => {'helper_id' => "1"})
  end

  describe ".add_reader" do
    it "should add a method named for the argument" do
      @helper.add_reader(:float_reader) {|x| x.to_f}
      @helper.should respond_to(:float_reader)
    end
  end

  describe ".reader" do
    describe "with a symbol" do
      it "adds a reader that returns the attribute by that key" do
        @helper.reader(:helper_id)
        @a_helper.should respond_to(:helper_id)
        @a_helper.helper_id.should == "1"
      end
    end

    describe "with a hash" do
      it "adds a reader that returns the corresponding element" do
        @helper.reader(:helper_id => :new_helper_id)
        @a_helper.should respond_to(:new_helper_id)
        @a_helper.new_helper_id.should == "1"
      end
    end

    describe "with a hash and a block" do
      it "adds a reader that returns the corresponding element, cast by calling the block" do
        @helper.reader(:helper_id => :succ_helper_id){|id| id.succ}
        @a_helper.should respond_to(:succ_helper_id)
        @a_helper.succ_helper_id.should == "1".succ
      end
    end
  end

  describe ".integer_reader" do
    it "adds a reader that casts the value to an integer" do
      @helper.integer_reader(:helper_id)
      @a_helper.helper_id.should == 1
    end
  end

  describe ".decimal_reader" do
    it "adds a reader that casts the value to an decimal" do
      @helper.decimal_reader(:helper_id)
      @a_helper.helper_id.should == BigDecimal.new("1")
    end
  end

  describe ".float_reader" do
    it "adds a reader that casts the value to an float" do
      @helper.float_reader(:helper_id)
      a_helper = @helper.new('Properties' => {'helper_id' => "1.9234"})
      a_helper.helper_id.should == Float("1.9234")
    end
  end

  describe ".boolean_reader" do
    it "adds a reader that casts the value to an boolean" do
      @helper.boolean_reader(:helper_id)
      @a_helper.helper_id.should == true
    end
  end
end
