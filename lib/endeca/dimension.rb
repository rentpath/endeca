module Endeca
  class Dimension
    include Comparable
    include Readers
    extend ClassToProc

    reader \
      "DimValueName"  => :name,
      "SelectionLink" => :selection_link,
      "RemovalLink"   => :removal_link

    integer_reader \
      "DimValueID"      => :id,
      "NumberofRecords" => :record_count

    attr_reader :raw
    def initialize(raw={})
      @raw=raw
    end
    alias_method :attributes, :raw
    
    def to_endeca_params
      selection_link || removal_link
    end

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
