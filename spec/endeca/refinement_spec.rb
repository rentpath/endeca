require File.join(File.dirname(__FILE__), %w[.. spec_helper])

describe Endeca::Refinement do
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
end
