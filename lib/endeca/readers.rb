module Endeca
  class ReaderError < ::StandardError; end

  module Readers
    def add_reader(name, &block)
      meta = (class << self; self; end)
      meta.instance_eval do
        define_method(name) { |*attrs| reader(*attrs, &block) }
      end
    end

    # Maps key/value pairs from the data structure used to initialize a
    # Endeca object. Allows attribute renaming. Use a block to perform data
    # injunction on the value as it is set.
    #
    # ==== Examples
    #
    #   # Specify basic attributes
    #   reader :title
    #
    #   # Attribute renaming
    #   reader :long_desc => :description
    #
    #   # Data injunction
    #   reader(:title => :upcased_title) { |title| title.upcase }
    def reader(*attrs,&block)
      hash = {}
      hash.update(attrs.pop) if Hash === attrs.last
      attrs.each do |attr|
        hash[attr] = attr
      end
      hash.each do |variable, method|
        variable = variable.to_s
        if block_given?
          define_method(method) do
            begin
              block.call(attributes[variable])
            rescue StandardError => e
              raise Endeca::ReaderError, e
            end
          end
        else
          define_method(method) { attributes[variable] }
        end
      end
    end

    # Typecasts attributes as integers.
    #
    # ==== Examples
    #   integer_reader :id, :rating
    def integer_reader(*attrs)
      reader(*attrs) { |value| Integer(value) }
    end

    # Typecasts attributes as BigDecimal
    #
    # ==== Examples
    #   decimal_reader :price
    def decimal_reader(*attrs)
      require 'bigdecimal' unless defined?(BigDecimal)
      reader(*attrs) { |value| BigDecimal(value.to_s) }
    end

    # Typecasts attributes as floats 
    #
    # ==== Examples
    #   float_reader :latitude, :longitude
    def float_reader(*attrs)
      reader(*attrs) { |value| Float(value) }
    end

    # Typecasts attributes as a Perly boolean ("0" == false, "1" == true")
    #
    # ==== Examples
    #   boolean_reader :price
    def boolean_reader(*attrs)
      reader(*attrs) { |value| value == "1" ? true : false }
    end

    def dim_reader(*attrs, &block)
      hash = {}
      block ||= lambda {|x| x}

      hash.update(attrs.pop) if Hash === attrs.last

      attrs.each{|attr| hash[attr] = attr}

      hash.each do |variable, method|
        define_method method do
          dim = dimensions[variable.to_s]
          name = dim && dim.name
          block.call(name)
        end
      end
    end
  end
end
