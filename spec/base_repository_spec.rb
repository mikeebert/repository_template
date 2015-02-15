require 'base_repository'
require 'ostruct'

describe BaseRepository do
  let(:repo) { BaseRepository.new }
  let(:some_object) { OpenStruct.new(id: 0) }

  context '#count' do
    it 'counts how many objects it has' do
      expect(repo.count).to eq 0
    end
  end

  context '#save' do
    it 'saves an object' do
      repo.save(some_object)
      expect(repo.count).to eq 1
    end

    it 'assigns an id to a saved object' do
      repo.save(some_object)
      expect(some_object.id).to eq 1
    end
  end

  context '#find' do
    it 'finds an object by id' do
      repo.save(some_object)
      expect(repo.find(some_object.id)).to eq some_object
    end

    it 'returns nil if no record exists for that id' do
      non_existent_id = 99
      expect(repo.find(non_existent_id)).to eq nil
    end
  end

  context '#delete' do
    it 'deletes its reference to an object' do
      repo.save(some_object)
      repo.delete(some_object.id)
      expect(repo.find(some_object.id)).to be nil
    end
  end
end
