module Endeca
  class Map
    def initialize(key, transformed_key)
      @key = key
      @transformed_key = transformed_key
      @join_with = "|"
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
      @join_with = character
      self
    end

    #
    def transform(&block)
      @transformation = &block
    end
  end
end
