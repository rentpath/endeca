require File.join(File.dirname(__FILE__), %w[.. spec_helper])

describe Endeca::Benchmarking do
  class Helper
    extend Endeca::Benchmarking
  end

  describe "#benchmark" do
    before do
      @logger = mock('Logger')

      Endeca.stub!(:logger).and_return(@logger)

      Benchmark.stub!(:ms => 1)
    end

    it "should log the title and the time to the Endeca logger" do
      @logger.should_receive(:debug).with("metric: 1.0ms")
      Endeca.bm(:metric){ 1 }
    end
  end

  describe "#add_bm_detail" do
    it "should add info to the current thread" do

      Endeca.send(:add_bm_detail, :metric, 1.1, 'query query')

      Thread.current[:endeca]["metric_detail"][0].should == {:detail => "query query", :time => 1.1}
    end
  end
end
