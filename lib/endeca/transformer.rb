module Endeca
  module Transformer
    # Requires existence of mappings accessor (Hash)
    #
    # ==== Examples
    #   # Standard map call that returns an Endeca::Map object
    #   map(:old_name => :new_name)
    #
    #   # Allows to to create a map object to perform other functionality such
    #   # as transformations.
    #   map(:new_name)
    def map(mapping = {})
      mapping = {mapping => mapping} if Symbol === mapping
      mapping = mapping.symbolize_keys

      if mapping.length > 1
        raise ArgumentError, "map only accepts one key=>value pair" 
      end

      mapping.each do |key, transformed_key|
        transformed_key = key unless transformed_key
        return mappings[key] = Map.new(key, transformed_key)
      end
    end

    # Use the mappings hash to replace domain level query query_options with
    # their Endeca equivalent.
    def transform_query_options(query_options)
      query = query_options.symbolize_keys
      query.keys.each do |key|
        if mapping = mappings[key]
          new_options = mapping.perform(query)
          query.delete(key)
          query.update(new_options)
        end
      end
      query
    end
 
  end
end
