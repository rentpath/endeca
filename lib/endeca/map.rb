module Endeca
  class Map
    attr_accessor :old_key, :new_key, :parent_hash, :delimiter, :transformation

    def initialize(old_key, new_key)
      @old_key = old_key
      @new_key = new_key 
    end

    # Mapping actually resides in another key, value pair.
    #
    # Example:
    #   map(:city => :propertycity).in(:ntk => ntt)
    #
    #   Document.all(:city => 'Atlanta')   =>
    #     ?ntk=propercity&ntt=>Atlanta
    def in(hash)
      @parent_hash = hash
      # do something with hash
      self
    end

    alias_method :as, :in

    # When multiple values occur for a key, use this character to join on
    def join(character)
      @delimiter = character
      self
    end

    # Code block to execute on the original data
    def transform(&block)
      @transformation = block
      self
    end

    # Perform the mapping as defined for the current_query
    def perform(current_query)
      @current_query = current_query

      perform_transformation
      perform_map
      perform_in
      perform_join

      return @new_query
    end

    # Mapping object is equal to other mapping object if their attributes
    # are equal
    def ==(other)
      @old_key == other.old_key &&
      @new_key == other.new_key &&
      @delimiter == other.delimiter  &&
      @transformation == other.transformation
    end

    private

    def perform_transformation
      current_value = @current_query[@old_key]
      @current_value = (@transformation || lambda{|x| x})[current_value]
    end

    def perform_map
      @new_query = {@new_key => @current_value}
    end

    def perform_in
      return unless @parent_hash
      old_key, old_value = @new_query.to_a.flatten
      new_key, new_value = @parent_hash.to_a.flatten
      @new_query = {new_key => old_key, new_value => old_value}
    end

    def perform_join
      return unless @delimiter
      @new_query.each do |key, value|
        @new_query[key] = [@current_query[key], value].compact.join(@delimiter)
      end
    end
  end
end
