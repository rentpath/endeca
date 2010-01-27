module Endeca
  class Refinement
    include Readers

    reader 'DimensionName' => :name,
      'ExpansionLink' => :expansion_link,
      'ContractionLink' => :contraction_link

    integer_reader 'DimensionID' => :id

    reader('DimensionValues' => :dimension_values) do |values|
      values.map{|value| Dimension.new(value)} if values
    end

    reader('Dimensions' => :dimensions) do |values|
      values.map{|value| RefinementDimension.new(value)} if values
    end

    attr_reader :raw
    def initialize(raw={})
      @raw = raw
    end

    def ==(other)
      id == other.id
    end

    def inspect
      "#<#{self.class}=0x#{self.object_id.to_s(16)} id=#{id} name=#{name.inspect}>"
    end

    def attributes
      (@raw['Dimensions'] || []).first || {}
    end

    def to_endeca_params
      expansion_link || contraction_link
    end

  end
end
