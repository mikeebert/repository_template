class BaseRepository
  def initialize
    @id = 1
    @objects = {}
  end

  def save(object)
    object.id = id
    objects[id] = object
    @id += 1
  end

  def find(object_id)
    objects[object_id]
  end

  def count
    objects.values.count
  end

  def delete(object_id)
    objects.delete object_id
  end

  private
  attr_accessor :id, :objects

end
