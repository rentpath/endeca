require File.join(File.dirname(__FILE__), %w[.. spec_helper])

describe Endeca::Readers do
  class Helper
    extend Endeca::Readers
  end

  before do
    @helper = Helper.new
    @helper.stub!(:attributes).and_return("helper_id" => "1")
  end

  describe ".add_reader" do
    it "should add a method named for the argument" do
      Helper.add_reader(:float_reader) {|x| x.to_f}
      Helper.should respond_to(:float_reader)
    end
  end

  describe ".reader" do
    describe "with a symbol" do
      it "adds a reader that returns the attribute by that key" do
        Helper.reader(:helper_id)
        @helper.should respond_to(:helper_id)
        @helper.helper_id.should == "1"
      end
    end

    describe "with a hash" do
      it "adds a reader that returns the corresponding element" do
        Helper.reader(:helper_id => :new_helper_id)
        @helper.should respond_to(:new_helper_id)
        @helper.new_helper_id.should == "1"
      end
    end

    describe "with a hash and a block" do
      it "adds a reader that returns the corresponding element, cast by calling the block" do
        Helper.reader(:helper_id => :succ_helper_id){|id| id.succ}
        @helper.should respond_to(:succ_helper_id)
        @helper.succ_helper_id.should == "1".succ
      end
    end
  end

  describe ".integer_reader" do
    it "adds a reader that casts the value to an integer" do
      Helper.integer_reader(:helper_id)
      @helper.helper_id.should == 1
    end
  end

  describe ".decimal_reader" do
    it "adds a reader that casts the value to an decimal" do
      Helper.decimal_reader(:helper_id)
      @helper.helper_id.should == BigDecimal.new("1")
    end
  end

  describe ".boolean_reader" do
    it "adds a reader that casts the value to an boolean" do
      Helper.boolean_reader(:helper_id)
      @helper.helper_id.should == true
    end
  end
end
