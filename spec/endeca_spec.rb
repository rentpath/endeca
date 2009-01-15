
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe Endeca do
  describe ".version" do
    it "returns the version string" do
      Endeca.version.should == Endeca::VERSION
    end
  end
end

# EOF
