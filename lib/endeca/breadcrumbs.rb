module Endeca
  module Breadcrumbs
    class TypeError < StandardError; end
    
    def self.include?(klass)
      self.const_defined?(klass)
    end
    
    def self.[](klass)
      self.const_get(klass)
    end
  end
end
