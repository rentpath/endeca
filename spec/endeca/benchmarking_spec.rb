require File.join(File.dirname(__FILE__), %w[.. spec_helper])

describe Endeca::Benchmarking do
  class Helper
    extend Endeca::Benchmarking
  end
  describe "#benchmark" do
    before do
      @logger = mock('Logger')

      Endeca.stub!(:logger).and_return(@logger)
      Endeca.stub!(:debug => true, :benchmark => true)

      Benchmark.stub!(:ms => 1)
    end

    it "should log the title and the time to the Endeca logger" do
      @logger.should_receive(:debug).with("title => 1.0ms")
      Endeca.bm("title => "){ 1 }
    end
  end
end
