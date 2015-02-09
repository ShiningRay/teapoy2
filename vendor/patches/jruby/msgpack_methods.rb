class Object
  def to_msgpack
    MessagePack.pack(self)
  end
end
