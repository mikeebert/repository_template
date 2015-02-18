class BaseObject
  UndefinedAttributes = Class.new(StandardError)
  BASE_ATTRIBUTES = [:id]

  def attr_accessors
    raise UndefinedAttributes.new('Please provide array of attributes with attr_accessors method in inheriting class.')
  end

  def initialize(params = nil)
    set_base_attrs
    update(params) if params
  end

  def attributes
    attrs.each_with_object({}) do |attr, hash|
      hash[attr] = self.send(attr)
    end
  end

  def update(new_attributes)
    new_attributes.each do |attr, value|
      self.send("#{attr}=", value)
    end
  end

  private

  def set_base_attrs
    attrs.each do |attr|
      instance_variable_set("@#{attr}", nil)
    end
  end

  def attrs
    BASE_ATTRIBUTES + attr_accessors
  end

  def method_missing(*args)
    method_call = args[0]
    attr_name = attr_name_for(args[0])
    raise UndefinedAttributes.new("Undefined Attribute: #{attr_name}") unless attrs.include?(attr_name.to_sym)

    if setter?(method_call)
      instance_variable_set("@#{attr_name}", args[1])
    else
      instance_variable_get("@#{attr_name}")
    end
  end

  def attr_name_for(arg)
    arg.to_s.gsub('=','')
  end

  def setter?(arg)
    arg.to_s.include? '='
  end
end
