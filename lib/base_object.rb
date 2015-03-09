module Attributes
  ID_ATTRIBUTE = :id

  def self.included(base)
    def base.attributes(*attribute_list)
      @attribute_list = attribute_list << ID_ATTRIBUTE
    end

    def base.attribute_list
      @attribute_list ||= []
    end
  end
end

class BaseObject
  include Attributes

  UndefinedAttributes = Class.new(StandardError)

  def initialize(params = nil)
    set_base_attributes
    update(params) if params
  end

  def update(new_attributes)
    new_attributes.each do |attr, value|
      self.send("#{attr}=", value)
    end
  end

  def attributes
    attrs.each_with_object({}) do |attr, hash|
      hash[attr] = self.send(attr)
    end
  end

  private

  def set_base_attributes
    attrs.each do |attr|
      instance_variable_set("@#{attr}", nil)
    end
  end

  def attrs
    @attribute_list ||= self.class.attribute_list

    if @attribute_list.empty?
      raise UndefinedAttributes.new("Please provide list of attr_accessors: i.e `attr_accessors :foo, :bar`")
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
