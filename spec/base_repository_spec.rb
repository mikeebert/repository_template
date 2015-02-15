require 'base_repository'

describe BaseRepository do
  class MockObject
    attr_accessor :id
  end

  let(:repo) { BaseRepository.new }
  let(:mock_object) { MockObject.new }

  context '#count' do
    it 'counts how many objects it has' do
      expect(repo.count).to eq 0
    end
  end

  context '#save' do
    it 'saves an object' do
      repo.save(mock_object)
      expect(repo.count).to eq 1
    end

    it 'assigns an id to a saved object' do
      repo.save(mock_object)
      expect(mock_object.id).to eq 1
    end

    it 're-saves an object to the same id' do
      repo.save(mock_object)
      expect(mock_object.id).to eq 1

      repo.save(mock_object)
      expect(mock_object.id).to eq 1
    end

    it 'raises a RecordNotFound error if trying to save object with id that does not exist' do
      mock_object.id = 99
      expect{ repo.save(mock_object) }.to raise_error(described_class::RecordNotFound)
    end
  end

  context '#find' do
    it 'finds an object by id' do
      repo.save(mock_object)
      expect(repo.find(mock_object.id)).to eq mock_object
    end

    it 'returns nil if no record exists for that id' do
      non_existent_id = 99
      expect(repo.find(non_existent_id)).to eq nil
    end
  end

  context '#delete' do
    it 'deletes its reference to an object' do
      repo.save(mock_object)
      repo.delete(mock_object.id)
      expect(repo.find(mock_object.id)).to be nil
    end
  end
end
