module Endeca
  module Transformer
    # Requires existence of mappings accessor
    def map(mapping = {})
      if mapping.length > 1
        raise ArgumentError, "map only accepts one key=>value pair" 
      end

      mapping.each do |key, transformed_key|
        return mappings[key] = Map.new(key, transformed_key)
      end
    end

    # Use the mappings hash to replace domain level query query_options with
    # their Endeca equivalent.
    def transform_query_options(query_options)
      query = query_options.dup
      query.each do |key, value|
        if mappings[key]
          new_options = mappings[key].perform(query_options)
          query_options.delete(key)
          query_options.update(new_options)
        end
      end
      query_options
    end
 
  end
end
