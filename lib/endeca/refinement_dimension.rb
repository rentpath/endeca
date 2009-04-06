module Endeca
  class RefinementDimension
    include Comparable
    include Readers
    extend ClassToProc

    reader \
      "DimensionName"  => :name,
      "ExpansionLink" => :to_endeca_params

    integer_reader \
      "DimensionID"      => :id

    attr_reader :raw
    def initialize(raw={})
      @raw=raw
    end
    alias_method :attributes, :raw
    
    def inspect
      "#<#{self.class}=0x#{self.object_id.to_s(16)} id=#{id} name=#{name.inspect}>"
    end

    def ==(other)
      id == other.id
    end

    def <=>(other)
      name <=> other.name
    end
  end
end
