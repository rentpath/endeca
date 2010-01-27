module Endeca
  
  class Breadcrumb
    include Readers

    def self.create(raw)
      name = raw['Type']
      breadcrumb_class = self

      if name    
        unless Breadcrumbs.include?(name)
          raise Breadcrumbs::TypeError, "Unknown breadcrumb type: #{name.inspect}" 
        end
        breadcrumb_class = Breadcrumbs[name]
      end

      breadcrumb_class.new(raw)
    end
    
    attr_reader :raw
    def initialize(raw={})
      @raw = raw
    end
    alias_method :attributes, :raw
    
    reader 'Type' => :type    
    def name; '' end

    def ==(other)
      name == other.name
    end

    def inspect
      "#<#{self.class}=0x#{self.object_id.to_s(16)} name=#{name.inspect}>"
    end

  end
end
