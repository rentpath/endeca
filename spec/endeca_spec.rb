require 'spec_helper'

describe Endeca do
  describe ".version" do
    it "returns the version string" do
      Endeca.version.should == Endeca::VERSION
    end
  end

  describe "#escape" do
    query = 'N=5875 5922&Nf=geocode|GCLT 26.121900,-80.143600 32.18688&Nu=mgtcoid&Ns=searchonly|0||isapartment|1||sortorder|0&Ntk=showapartment|mgtcologodisplay&F=cityseopath:1|mediummgtcologo:1|mgtcodescription:1|mgtcoid:1|mgtcologo:1|mgtcologodisplay:1|mgtconame:1|msa_code:1|propertycity:1|propertystatelong:1|smallmgtcologo:1|webtollfree:1|mvtphone:1&Ntt=1|1&M=recs_per_page:99999|expand_all_dims:0'

    Endeca.escape(query).should == 'N=5875%205922&Nf=geocode%7CGCLT%2026.121900,-80.143600%2032.18688&Nu=mgtcoid&Ns=searchonly%7C0%7C%7Cisapartment%7C1%7C%7Csortorder%7C0&Ntk=showapartment%7Cmgtcologodisplay&F=cityseopath%3A1%7Cmediummgtcologo%3A1%7Cmgtcodescription%3A1%7Cmgtcoid%3A1%7Cmgtcologo%3A1%7Cmgtcologodisplay%3A1%7Cmgtconame%3A1%7Cmsa_code%3A1%7Cpropertycity%3A1%7Cpropertystatelong%3A1%7Csmallmgtcologo%3A1%7Cwebtollfree%3A1%7Cmvtphone%3A1&Ntt=1%7C1&M=recs_per_page%3A99999%7Cexpand_all_dims%3A0'

  end

  it "#debug?" do
    ENV['ENDECA_DEBUG'] = 'true'

    Endeca.debug?.should == true

    ENV['ENDECA_DEBUG'] = 'false'

    Endeca.debug?.should == false
  end

  it "#benchmark?" do
    ENV['ENDECA_BENCHMARK'] = 'true'

    Endeca.benchmark?.should == true

    ENV['ENDECA_BENCHMARK'] = 'false'

    Endeca.benchmark?.should == false
  end

end

# EOF
