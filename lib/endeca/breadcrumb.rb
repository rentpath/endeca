module Endeca
  class Breadcrumb
    extend ClassToProc
    extend Readers

    reader \
      'DimensionName' => :name,
      'Type' => :type,
      'DimensionRemovalLink' => :to_params

    reader('DimensionValues' => :dimension_values) do |values|
      values.map(&Dimension) if values
    end

    attr_reader :raw
    def initialize(raw={})
      @raw = raw
    end

    def ==(other)
      name == other.name
    end

    def inspect
      "#<#{self.class}=0x#{self.object_id.to_s(16)} name=#{name.inspect}>"
    end

    def attributes
      (@raw['Dimensions'] || []).first || {}
    end

  end
end
