require File.join(File.dirname(__FILE__), %w[.. spec_helper])

describe Endeca::Refinement do
  before do
    @refinement = Endeca::Refinement.new
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
      @refinement.inspect.should include('id:1')
    end

    it "includes the inspected name" do
      @refinement.stub!(:name).and_return('A Name')
      @refinement.inspect.should include('name:"A Name"')
    end
  end
end
