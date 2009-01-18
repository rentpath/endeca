module Endeca
  module Transformer
    # Requires existence of mappings accessor
    def map(mapping = {}, &transformation)
      mapping.each do |key, transformed_key|
        mappings[key] = [transformed_key, transformation]
      end
    end

    # Use the mappings hash to replace domain level query query_options with
    # their Endeca equivalent.
    def transform_query_options(query_options)
      query_options = query_options.dup
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
