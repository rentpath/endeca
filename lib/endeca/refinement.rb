module Endeca
  class Refinement
    extend ClassToProc

    attr_reader :id, :name, :expansion_link
    def initialize(values={})
      @id   = values['DimensionID']
      @name = values['DimensionName']
      @expansion_link = values['ExpansionLink']
    end

    alias_method :to_query, :expansion_link
  end
end
