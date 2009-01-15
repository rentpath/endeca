module Endeca
  class Refinement
    extend ClassToProc
    extend Readers

    attr_reader :raw
    def initialize(raw={})
      @raw = raw
    end

    def ==(other)
      id == other.id
    end

    def inspect
      "#<#{self.class}:0x#{self.object_id.to_s(16)} id:#{id} name:#{name}>"
    end

    def attributes
      (@raw['Dimensions'] || []).first || {}
    end

    reader \
      'DimensionName' => :name,
      'ExpansionLink' => :to_params

    integer_reader 'DimensionID' => :id
  end
end
