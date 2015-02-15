class BaseRepository
  RecordNotFound = Class.new(StandardError)

  def initialize
    @id = 1
    @objects = {}
  end

  def count
    objects.count
  end

  def save(object)
    if object.id.nil?
      save_new(object)
    else
      save_existing(object)
    end
  end

  def find(object_id)
    objects[object_id]
  end

  def delete(object_id)
    objects.delete(object_id)
  end

  private
  attr_accessor :id, :objects

  def save_new(object)
    object.id = id
    objects[id] = object
    @id += 1
  end

  def save_existing(object)
    if objects.include?(object.id)
      objects[object.id] = object
    else
      raise RecordNotFound.new("No existing record for id: #{object.id}")
    end
  end
end
