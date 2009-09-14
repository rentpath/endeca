module Endeca
  class Map
    def initialize(old_key, new_key=nil)
      @old_key = old_key
      @new_key = new_key || @old_key
      boolean
    end

    # Convert true and false into their Endeca equivalents
    def boolean
      @boolean = true
      add_transformation { |value| value == true ? 1 : value }
      add_transformation { |value| value == false ? 0 : value }
      self
    end

    def boolean?; @boolean end

    # Mapping actually resides in another key, value pair. Uses Endeca default
    # join characters (can be overridden by specifying +with+ and/or +join+).
    #
    # Example:
    #   map(:city => :propertycity).into(:ntk => :ntt)
    #
    #   Document.all(:city => 'Atlanta')   =>
    #     ?ntk=propercity&ntt=>Atlanta
    def into(hash)
      hash = hash.intern if hash.respond_to?(:intern)
      if hash.is_a?(Hash)
        raise ArgumentError, "Only one key/value pair allowed" if hash.size > 1        
        hash = hash.to_a.flatten
        hash = {hash.first.to_sym => hash.last.to_sym}
      end
      @into = hash
      with ':'
      join '|'
      self
    end

    def into?; @into end

    # Mapping actually resides in another key, value pair. Uses Endeca default
    # join characters (can be overridden by specifying +with+ and/or +join+).
    #
    # Example:
    #   map(:city => :propertycity).split_into(:ntk => :ntt)
    #
    #   Document.all(:city => 'Atlanta, New York, Los Angeles')   =>
    #     ?ntk=propercity|propertycity|propertycity&ntt=>Atlanta|New York|Los Angeles
    def split_into(hash, split_value = ',')
      into(hash)
      @split_value = split_value
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

    def join?; @join end

    # Code block to execute on the original data
    def transform(&block)
      add_transformation block
      self
    end

    # When mapping multiple values, enclose the values in the string provided
    # to +enclose+.
    def enclose(str)
      @enclose = str
      self
    end

    def enclose?; @enclose end

    # When mapping multiple key/value pairs, replace existing keys with the new
    # keys rather than joining.
    def replace!
      @replace = true
      self
    end

    def replace?; @replace end

    # Perform the mapping as defined for the current_query
    def perform(current_query)
      @current_query = current_query.symbolize_keys
      @current_value = @current_query[@old_key]

      perform_transformation
      perform_map
      perform_into
      perform_join

      return @new_query
    end

    # Mapping object is equal to other mapping object if their attributes
    # are equal
    def ==(other)
      equality_elements == other.equality_elements
    end

    def inspect
      perform({ 'old_key' => "inspect_data" }).inspect
    end

    private

    def transformations
      @transformations ||= []
    end

    def transformations?
      !transformations.empty?
    end

    def add_transformation(transformation = nil, &block)
      transformations.push transformation if transformation
      transformations.push block if block_given?
    end

    def perform_transformation
      return unless transformations?
      current_value = @current_value
      transformations.each do |transformation|
        current_value = transformation.call(current_value)
      end
      @current_value = current_value
    end

    def perform_map
      @new_query = {@new_key => @current_value}.symbolize_keys
    end

    def perform_into
      return unless into?
      
      old_key, old_value = Array(@new_query).flatten
      new_key, new_value = Array(@into).flatten

      if new_value
        if @split_value
          @new_query = perform_split(old_key, old_value, new_key, new_value)
        else
          @new_query = {new_key => old_key, new_value => old_value}
        end
      else
        new_value = [old_key, old_value].compact.join(@with)
        new_value = "#{@enclose}(#{new_value})" if enclose?
        @new_query = {new_key => new_value}
      end
    end

    def perform_join
      return unless join?
      return if replace?

      @new_query.each do |key, value|
        @new_query[key] = [@current_query[key], value].compact.join(@join)
      end
    end

    protected

    def perform_split(old_key, old_value, new_key, new_value)
      key = []
      value = [] 
      old_value.split(@split_value).each do |val|
        key << old_key
        value << val
      end

      {new_key => key.join(@join), new_value => value.join(@join)}
    end

    def equality_elements # :nodoc:
      [@old_key, @new_key, @join, @with, @join]
    end
  end
end
