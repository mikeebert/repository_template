class BaseObject
  ID_ATTRIBUTE = :id
  UndefinedAttributes = Class.new(StandardError)

  def self.attributes(*attribute_list)
    @attribute_list = attribute_list << ID_ATTRIBUTE
  end

  def initialize(params = nil)
    set_base_attributes
    update(params) if params
  end

  def update(new_attributes)
    new_attributes.each do |attr, value|
      self.send("#{attr}=", value)
    end
  end

  def to_h
    attrs.each_with_object({}) do |attr, hash|
      hash[attr] = self.send(attr)
    end
  end

  private

  def self.attribute_list
    @attribute_list ||= []
  end

  def set_base_attributes
    attrs.each do |attr|
      instance_variable_set("@#{attr}", nil)
    end
  end

  def attrs
    @attribute_list ||= self.class.attribute_list

    if @attribute_list.empty?
      raise UndefinedAttributes.new("Missing attributes list in class: #{self.class}")
    else
      @attribute_list
    end
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
