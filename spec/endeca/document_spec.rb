require File.join(File.dirname(__FILE__), %w[.. spec_helper])

describe Endeca::Document do
  before do
    Endeca::Document.path 'http://endeca.example.com'
    @document = Endeca::Document.new
  end

  describe '.map' do
    after do
      Endeca::Document.mappings = {}
    end

    describe "with a mapping value" do
      it "should assign the mapping with a nil transformation" do
        Endeca::Document.map(:id => :endecaID)
        map = Endeca::Map.new :id, :endecaID
        Endeca::Document.mappings.should include({:id => map})
      end
    end

    describe "with two maps that join on the same key in a parent hash" do
      it "should join the key and value on the delimiter" do
        Endeca::Document.map(:state => :propertystate).into(:ntk => :ntt)
        Endeca::Document.map(:city => :propertycity).into(:ntk => :ntt)
        [
          {:ntk=>"propertycity|propertystate", :ntt=>"Atlanta|Georgia"},
          {:ntk=>"propertystate|propertycity", :ntt=>"Georgia|Atlanta"}
        ].should include Endeca::Document.transform_query_options(:city => 'Atlanta', :state => 'Georgia')
      end
    end

    describe "with two maps that join on the same key without mapping to a hash" do
      it "should join on the delimiter" do
        Endeca::Document.map(:limit => :recs_per_page).into(:M)
        Endeca::Document.map(:expand_refinements => :expand_all_dims).into(:M)

        # Hashes are not ordered and order is not important
        [{:M => "recs_per_page:10|expand_all_dims:1"}, {:M => "expand_all_dims:1|recs_per_page:10"}].
          should include(Endeca::Document.transform_query_options(:limit => 10, :expand_refinements => 1))
      end
    end
  end

  describe '.find' do
    before do
      @query_options = {:foo => :bar}
    end

    describe '#==' do
      it "should compare documents by id" do
        id = 1
        doc_1 = Endeca::Document.new
        doc_1.stub!(:id).and_return(id)
        doc_2 = Endeca::Document.new
        doc_2.stub!(:id).and_return(id)

        (doc_1 == doc_2).should be_true

        doc_2.stub!(:id).and_return(2)

        (doc_1 == doc_2).should be_false
      end
    end

    describe '#inspect' do
      it "includes the class name" do
        @document.inspect.should include(Endeca::Document.name)
      end

      it "includes the hex string of the object id" do
        @document.inspect.should include("0x#{@document.object_id.to_s(16)}")
      end
    end

    describe "#dimensions" do
      describe "with a nil Dimensions hash" do
        it "should be empty" do
          @document.stub!(:raw).and_return({})
          @document.dimensions.should be_empty
        end
      end

      describe 'with a raw Dimensions hash with a key "key" with one element' do
        it 'should return a hash with an array of that element at the key "key"' do
          dimension_hash = mock('Dimension Hash')
          dimension = mock(Endeca::Dimension)

          @document.
            stub!(:raw).
            and_return({'Dimensions' => {"key" => dimension_hash}})

          Endeca::Dimension.
            should_receive(:new).
            with(dimension_hash).
            and_return(dimension)

          @document.dimensions["key"].should == [dimension]
        end
      end
    end

    describe 'with :first' do
      it 'should call .first and pass the query options' do
        Endeca::Document.should_receive(:first).with(@query_options)
        Endeca::Document.find(:first, @query_options)
      end
    end

    describe 'with :all' do
      it "should call .all and pass the query options and self" do
        Endeca::Document.should_receive(:all).with(@query_options)
        Endeca::Document.find(:all, @query_options)
      end
    end

    describe 'with an Integer' do
      it "should call .by_id with the argument and the query options" do
        id = 5
        Endeca::Document.should_receive(:by_id).with(id, @query_options)
        Endeca::Document.find(id, @query_options)
      end
    end

    describe 'with an id string' do
      it "should call .by_id with the argument and the query options" do
        id = '5'
        Endeca::Document.should_receive(:by_id).with(id, @query_options)
        Endeca::Document.find(id, @query_options)
      end
    end

    describe 'with only query options' do
      it 'should call .all with the query options' do
        Endeca::Document.should_receive(:all).with(@query_options)
        Endeca::Document.find(@query_options)
      end
    end
  end

  describe ".first" do
    it "should make a request with the correct query" do
      Endeca::Request.
        should_receive(:perform).
        with('http://endeca.example.com', {:id => '1234'}).
        and_return({'Records' => []})

      Endeca::Document.first(:id => '1234')
    end

    it "should instantiate a new Endeca::Document from the first record in the response hash" do
      hash = {'Records' => [:document]}
      Endeca::Request.stub!(:perform).and_return(hash)
      Endeca::Document.
        should_receive(:new).
        with(:document)
      Endeca::Document.first(:id => '1234')
    end
  end

  describe '.by_id' do
    it 'should merge the id into the query options and call .first' do
      Endeca::Document.should_receive(:first).with(:id => '1234')
      Endeca::Document.by_id('1234')
    end
  end

  describe '.all' do
    before do
      @query_options = {:foo => :bar}
      @records = mock('RecordArray')
      @response = {'Records' => @records}
      Endeca::Document.
        stub!(:request).
        and_return(@response)
    end

    it 'should perform a request with the query options' do
      Endeca::Document.
        should_receive(:request).
        with(@query_options).
        and_return(@response)

      Endeca::Document.all(@query_options)
    end

    it 'should create a new DocumentCollection from the full response and the document class' do
      Endeca::DocumentCollection.should_receive(:new).with(@response, Endeca::Document)
      Endeca::Document.all(@query_options)
    end
  end

  describe ".transform_query_options" do
    before do
      @query_options = {
        :id => 5
      }
    end

    after do
      Endeca::Document.mappings = {}
    end

    describe "when there is no mapping for the given key" do
      it "returns the query options without modification" do
        Endeca::Document.transform_query_options(@query_options).
          should == @query_options
      end
    end

    describe "when there is a mapping with" do
      describe "a new key" do
        before do
          Endeca::Document.map(:id => :new_id)
        end

        it "should replace the key with the new key" do
          new_query_options = Endeca::Document.
            transform_query_options(@query_options)

          new_query_options.should == {:new_id => 5}
        end
      end

      describe "a new key and a value transformation" do
        before do
          Endeca::Document.map(:id => :new_id).transform {|id| id.to_s}
        end

        it "should replace the value with the transformed value" do
          Endeca::Document.transform_query_options(@query_options).
            should == {:new_id => "5"}
        end

        describe "that includes the current value" do
          before do
            Endeca::Document.map(:name => :new_name) do |name, current|
              [current,name].compact.join('|')
            end

            @current_query_options = {:name => 'bar', :new_name => 'foo'}
          end

          it "should transform the new value with the current value" do
            pending("Not sure of the use case.") do
              expected_name = "foo|bar"
              Endeca::Document.transform_query_options(@current_query_options).
                should == {:new_name => expected_name}
            end
          end
        end
      end
    end
  end
end
