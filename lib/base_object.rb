class BaseObject
  UndefinedAttributes = Class.new(StandardError)
  BASE_ATTRIBUTES = [:id]

  def initialize
    attrs.each do |attr|
      instance_variable_set("@#{attr}", nil)
    end
  end

  def attr_accessors
    raise UndefinedAttributes.new('Please define object attributes within an attrs method in your object.')
  end

  def attrs
    BASE_ATTRIBUTES + attr_accessors
  end

  def attributes
    attrs.each_with_object({}) do |attr, hash|
      hash[attr] = self.send(attr)
    end
  end

  def method_missing(*args)
    method_call = args[0]
    attr_name = attr_name_for(args[0])
    raise NoMethodError.new("Undefined Attribute: #{attr_name}") unless attrs.include?(attr_name.to_sym)

    if setter?(method_call)
      instance_variable_set("@#{attr_name}", args[1])
    else
      instance_variable_get("@#{attr_name}")
    end
  end

  private

  def attr_name_for(arg)
    arg.to_s.gsub('=','')
  end

  def setter?(arg)
    arg.to_s.include? '='
  end
end
