class Array
  def to_params
    join('&').to_params
  end
end

class Class
  def inherited_property(accessor, default = nil)
    instance_eval <<-RUBY, __FILE__, __LINE__ + 1
      @#{accessor} = default

      def set_#{accessor}(value)
        @#{accessor} = value
      end
      alias #{accessor} set_#{accessor}

      def get_#{accessor}
        return @#{accessor} if instance_variable_defined?(:@#{accessor})
        superclass.send(:#{accessor})
      end
    RUBY

    # @path = default
    #
    # def set_path(value)
    #   @path = value
    # end
    # alias_method path, set_path

    # def get_path
    #   return @path if instance_variable_defined?(:path)
    #   superclass.send(:path)
    # end
  end

  def inherited_accessor(accessor, default = nil)
    instance_eval <<-RUBY, __FILE__, __LINE__ + 1
      class << self; attr_writer :#{accessor}; end
      @#{accessor} = default

      def #{accessor}
        return @#{accessor} if instance_variable_defined?(:@#{accessor})
        superclass.send(:#{accessor})
      end
    RUBY
  end
end

class Hash
  def to_params
    map { |k, v|
      if v.instance_of?(Hash)
        v.map { |sk, sv|
          "#{k}[#{sk}]=#{sv}"
        }.join('&')
      else
        "#{k}=#{v}"
      end
    }.join('&').to_params
  end
  
  def symbolize_keys
    inject({}) do |options, (key, value)|
      options[(key.to_sym rescue key) || key] = value
      options
    end
  end
  
end

class NilClass
  def to_params
    ''
  end
end

class String
  def to_params
    Endeca.escape(self)
  end
end
