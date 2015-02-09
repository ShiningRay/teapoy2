# coding: utf-8
class MessagePackColumn
  RESCUE_ERRORS = [ MessagePack::UnpackError ]

  attr_accessor :object_class

  def initialize(object_class = Object)
    @object_class = object_class
  end

  def dump(obj)
    obj.to_msgpack
  end

  def load(msg)
    return object_class.new if object_class != Object && msg.nil?
    return msg unless msg.is_a?(String)

    begin
      obj = MessagePack.unpack(msg)

      unless obj.is_a?(object_class) || obj.nil?
        raise SerializationTypeMismatch,
          "Attribute was supposed to be a #{object_class}, but was a #{obj.class}"
      end
      obj ||= object_class.new if object_class != Object
      obj = obj.nested_under_indifferent_access if obj.is_a?(Hash)
      obj
    rescue *RESCUE_ERRORS
      {}
    end
  end
end

