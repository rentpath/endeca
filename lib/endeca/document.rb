module Endeca
  # Endeca Documents provide accessors for document properties
  # returned by an Endeca query. Interesting Document properties must be
  # declared with reader to be accessible on the object.
  #
  # The +reader+ declaration provided by Readers can also handle basic data transformations (i.e.
  # typecasting) and a few basic examples are provided (i.e. +integer_reader+).
  class Document
    include Readers
    extend Transformer

    inherited_accessor :mappings, {}
    inherited_property :path
    inherited_property :default_params, {}
    inherited_property :collection_class, DocumentCollection

    inherited_accessor :reader_names, []
    def self.field_names; reader_names; end

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

    def self.inspect
      return <<-INSPECT
#<#{self}>
Path: #{get_path.inspect}
Collection Class: #{get_collection_class.inspect}"
Mappings:\n\t#{mappings.collect{|k,v| "#{k}: #{v.inspect}\n\t"}.to_s}
DefaultParams:\n\t#{get_default_params.collect{|k,v| "#{k}: #{v.inspect}\n\t"}.to_s}
      INSPECT
    end

    def inspect
      "#<#{self.class}:0x#{self.object_id.to_s(16)}>"
    end

    # Returns the collection of Endeca::Dimension for the given Document
    def dimensions
      return @dimensions if @dimensions
      @dimensions = {}
      (raw['Dimensions'] || {}).each do |name, values|
        values = [values] unless Array === values
        @dimensions[name] = values.map{|value| Dimension.new(value)}
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
      when :first
        first(query_options)
      when :all
        all(query_options)
      when Integer, /^[A-Za-z\d]+$/
        by_id(what, query_options)
      when String
        all(what)
      else
        all(what)
      end
    end


    # Returns the first Document matching the query options.
    def self.first(query_options={})
      response = request(query_options)
      record = if response['AggrRecords']
        response['AggrRecords'].first['Records'].first
      elsif response['Records']
        response['Records'].first
      else
        nil
      end

      record && new(record)
    end

    # Returns all Documents matching the query options.
    def self.all(query_options={})
      get_collection_class.new(request(query_options), self)
    end

    # Returns a Document by id
    def self.by_id(id, query_options={})
      first(query_options.merge(id: id, skip_default_endeca_parameters: true))
    end

    private

    def self.request(query_options)
      Endeca::Request.perform(get_path, parse_query_options(query_options))
    end

    def self.parse_query_options(query_options)
      if query_options.respond_to?(:merge)
        unless query_options.delete(:skip_default_endeca_parameters)
          query_options = get_default_params.merge(query_options)
        end

        transform_query_options(query_options)
      else
        URI.unescape(query_options)
      end
    end
  end
end
