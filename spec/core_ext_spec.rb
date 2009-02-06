require File.join(File.dirname(__FILE__), %w[spec_helper])

describe Array do
  describe "#to_params" do
    it "should join the elements with ampersand" do
      ["foo=1","bar=3"].to_params.should == "foo=1&bar=3"
    end

    it "should escape all elements" do
      ['|=|','||=||'].to_params.should == '%7C=%7C&%7C%7C=%7C%7C'
    end
  end
end

describe Hash do
  describe "#to_params" do
    it "should join a key-value pair with equals" do
      {:foo => :bar}.to_params.should == 'foo=bar'
    end

    it "should join two key-value pairs with ampersand" do
      result = {:foo => :bar, :bizz => :bazz}.to_params
      (result == 'foo=bar&bizz=bazz' || result == 'bizz=bazz&foo=bar').should be_true
    end

    it "should use brackets to indicate a nested hash" do
      {:foo => {:foo => :bar}}.to_params.should == 'foo[foo]=bar'
    end

    it "should escape all elements" do
      {'|' => '||'}.to_params.should == '%7C=%7C%7C'
    end
  end
end

describe NilClass do
  describe "to_params" do
    it "should return the empty string" do
      nil.to_params.should == ''
    end
  end
end

describe String do
  describe "#to_params" do
    it "should URI escape the contents" do
      '|'.to_params.should == '%7C'
    end
    
    it "should URI escape a colon" do
      ':'.to_params.should == "%3A"
    end
  end
end

# EOF
