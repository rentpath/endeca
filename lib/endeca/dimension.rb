module Endeca
  class Dimension
    include Comparable
    extend ClassToProc
    extend Readers

    attr_reader :raw
    def initialize(raw={})
      @raw=raw
    end
    alias_method :attributes, :raw

    reader "DimValueName" => :name
    reader "PivotLink"    => :to_params

    integer_reader "DimValueID" => :id

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
