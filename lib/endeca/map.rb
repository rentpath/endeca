module Endeca
  class Map
    attr_accessor :old_key, :new_key, :parent_hash, :delimiter, :transformation

    def initialize(old_key, new_key)
      @old_key = old_key
      @new_key = new_key 
    end

    # Mapping actually resides in another key, value pair. Uses Endeca default
    # join characters (can be overridden by specifying +with+ and/or +join+).
    #
    # Example:
    #   map(:city => :propertycity).in(:ntk => ntt)
    #
    #   Document.all(:city => 'Atlanta')   =>
    #     ?ntk=propercity&ntt=>Atlanta
    def into(hash)
      @into = hash
      @with ||= ':'
      @join ||= '|'
      # do something with hash
      self
    end

    # When mapping multiple key/value pairs to a single parameter value (via
    # +into+), use this character to join a key with a value.
    def with(character)
      @with = character
      self
    end

    # When mapping multiple key/value pairs to one or two parameter values (via
    # +into+), use this character to join each pair.
    def join(character)
      @join = character
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
      perform_into
      perform_join

      return @new_query
    end

    # Mapping object is equal to other mapping object if their attributes
    # are equal
    def ==(other)
      @old_key == other.old_key &&
      @new_key == other.new_key &&
      @join == other.delimiter  &&
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

    def perform_into
      return unless @into
      old_key, old_value = Array(@new_query).flatten
      new_key, new_value = Array(@into).flatten
      if new_value
        @new_query = {new_key => old_key, new_value => old_value}
      else
        @new_query = {new_key => [old_key, old_value].join(@with || ':')}
      end
    end

    def perform_join
      return unless @join
      @new_query.each do |key, value|
        @new_query[key] = [@current_query[key], value].compact.join(@join)
      end
    end
  end
end
