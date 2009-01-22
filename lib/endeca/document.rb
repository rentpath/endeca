module Endeca
  # Endeca Documents provide accessors for document properties
  # returned by an Endeca query. Interesting Document properties must be
  # declared with reader to be accessible on the object.
  #
  # The +reader+ declaration provided by Readers can also handle basic data transformations (i.e.
  # typecasting) and a few basic examples are provided (i.e. +integer_reader+).
  class Document
    extend ClassToProc
    extend Readers
    extend Transformer

    inherited_accessor :mappings, {}
    inherited_property :path
    inherited_property :default_params, {}

    reader :id

    attr_reader :raw, :properties
    def initialize(record_raw=nil)
      @raw        = record_raw || {}
      @properties = @raw['Properties'] || {}
    end

    alias_method :attributes, :properties

    def ==(other)
      id == other.id
    end

    def inspect
      "#<#{self.class}:0x#{self.object_id.to_s(16)}>"
    end

    # Returns the collection of Endeca::Dimension for the given Document
    def dimensions
      return @dimensions if @dimensions
      @dimensions = {}
      (raw['Dimensions'] || {}).each do |name, value|
        @dimensions[name] = Dimension.new(value)
      end
      @dimensions
    end

    # Find operates with three distinct retrieval approaches:
    #
    # * Find by id - This is a specific id (1) or id string ("1")
    # * Find first - This will return the first record matching the query options
    #   used
    # * Find all - This will return a collection of Documents matching the
    #   query options. This is the default behavior of find if only query options
    #   are passed.
    #
    # ==== Parameters
    #
    # Find accepts a query options hash. These options are either passed
    # directly to Endeca or mapped (by use of +map+) to new parameters that are
    # passed to Endeca.
    #
    # ==== Examples
    #
    #   # find by id
    #   Listing.find(1)   # returns the Document for ID = 1
    #   Listing.find('1') # returns the Document for ID = 1
    #
    #   # find all
    #   Listing.find(:all) # returns a collection of Documents 
    #   Listing.find(:all, :available => true)
    #
    #   # find first
    #   Listing.find(:first) # Returns the first Document for the query
    #   Listing.find(:first, :available => true)
    def self.find(what, query_options={})
      case what
      when Integer, /^\d+$/
        by_id(what, query_options)
      when :first
        first(query_options)
      when :all
        all(query_options)
      else
        all(what)
      end
    end

    # Returns the first Document matching the query options.
    def self.first(query_options={})
      records = request(query_options)['Records']
      records && new(records.first)
    end

    # Returns all Documents matching the query options.
    def self.all(query_options={})
      DocumentCollection.new(request(query_options), self)
    end

    # Returns a Document by id
    def self.by_id(id, query_options={})
      first(query_options.merge(:id => id))
    end

    def self.group_by(grouping, query_options={}) # :nodoc:
      #DocumentCollection.new(request(query_options)['Records'])
    end

    private

    def self.request(query_options)
      query_options = transform_query_options(query_options.merge(get_default_params))
      Endeca::Request.perform(get_path, query_options)
    end
  end
end
