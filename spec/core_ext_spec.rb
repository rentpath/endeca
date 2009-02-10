require File.join(File.dirname(__FILE__), %w[spec_helper])

describe Array do
  describe "#to_endeca_params" do
    it "should join the elements with ampersand" do
      ["foo=1","bar=3"].to_endeca_params.should == "foo=1&bar=3"
    end

    it "should escape all elements" do
      ['|=|','||=||'].to_endeca_params.should == '%7C=%7C&%7C%7C=%7C%7C'
    end
  end
end

describe Benchmark do
  describe ".realtime" do
    it "should check the time twice" do
      Time.should_receive(:now).exactly(2).times
      Benchmark.realtime(){}
    end

    it "should return the time difference as a float" do
      Benchmark.realtime(){}.should be_a_kind_of(Float)
    end
  end
  
  describe ".ms" do
    it "should be 1000 times the realtime value" do
      Benchmark.stub!(:realtime).and_return(1)
      Benchmark.ms.should == 1000
    end
  end
end

describe Hash do
  describe "#to_endeca_params" do
    it "should join a key-value pair with equals" do
      {:foo => :bar}.to_endeca_params.should == 'foo=bar'
    end

    it "should join two key-value pairs with ampersand" do
      result = {:foo => :bar, :bizz => :bazz}.to_endeca_params
      (result == 'foo=bar&bizz=bazz' || result == 'bizz=bazz&foo=bar').should be_true
    end

    it "should use brackets to indicate a nested hash" do
      {:foo => {:foo => :bar}}.to_endeca_params.should == 'foo[foo]=bar'
    end

    it "should escape all elements" do
      {'|' => '||'}.to_endeca_params.should == '%7C=%7C%7C'
    end
  end
end

describe NilClass do
  describe "to_endeca_params" do
    it "should return the empty string" do
      nil.to_endeca_params.should == ''
    end
  end
end

describe String do
  describe "#to_endeca_params" do
    it "should URI escape the contents" do
      '|'.to_endeca_params.should == '%7C'
    end
    
    it "should URI escape a colon" do
      ':'.to_endeca_params.should == "%3A"
    end
  end
end

# EOF
