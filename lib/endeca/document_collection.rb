module Endeca
  class DocumentCollection
    attr_reader :raw
    def initialize(raw)
      @raw = raw
    end
  end
end
