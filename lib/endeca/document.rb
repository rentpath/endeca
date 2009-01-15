module Endeca
  class Document
    extend ClassToProc
    extend Readers

    inherited_accessor :mappings, {}
    inherited_property :path

    reader :id

    def self.map(mapping={}, &transformation)
      mapping.each do |key, transformed_key|
        mappings[key] = [transformed_key, transformation]
      end
    end

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

    def dimensions
      @dimensions = {}
      (raw['Dimensions'] || {}).each do |name, values|
        values = Array === values ? values : [values]
        @dimensions[name] = values.map(&Dimension)
      end
      @dimensions
    end

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

    def self.first(query_options={})
      new(request(query_options)['Records'].first)
    end

    def self.all(query_options={})
      DocumentCollection.new(request(query_options), self)
    end

    def self.by_id(id, query_options={})
      first(query_options.merge(:id => id))
    end

    def self.group_by(grouping, query_options={})
      #DocumentCollection.new(request(query_options)['Records'])
    end

    private

    def self.request(query_options)
      query_options = transform_query_options(query_options)
      Endeca::Request.perform(get_path, query_options)
    end

    # Use the mappings hash to replace domain level query query_options with
    # their Endeca equivalent.
    def self.transform_query_options(query_options)
      query_options.each do |key, value|
        if mappings[key]
          query_options.delete(key)
          new_key, transformation = mappings[key]
          current = query_options[new_key]
          transformation ||= lambda { |x| x } # identity
          result = case transformation.arity
                   when 1; transformation.call(value)
                   when 2; transformation.call(value, current)
                   end
          query_options.update({new_key => result})
        end
      end
      query_options
    end
  end
end
