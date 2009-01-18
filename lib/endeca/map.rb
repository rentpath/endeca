module Endeca
  class Map
    attr_accessor :old_key, :new_key, :parent_hash, :delimiter, :transformation

    def initialize(old_key, new_key)
      @old_key = old_key
      @new_key = new_key 
      @delimiter = "|"
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
    def join_with(character)
      @delimiter = character
      self
    end

    # Code block to execute on the original data
    def transform(&block)
      @transformation = block
      self
    end

    # Perform the mapping as defined for the current_value
    def perform(current_value)
      result = if @transformation
                 @transformation.call(current_value)
               else
                 current_value
               end

      if @parent_hash
        @new_key = {@parent_hash.keys.first => @new_key}
        result   = {@parent_hash.values.first => result}
      end

      return @new_key, result 
    end

    # Mapping object is equal to other mapping object if their attributes
    # are equal
    def ==(other)
      @old_key == other.old_key &&
      @new_key == other.new_key &&
      @delimiter == other.delimiter  &&
      @transformation == other.transformation
    end
  end
end
