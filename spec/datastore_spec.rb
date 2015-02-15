require 'datastore'
require 'pry'

describe Datastore do
  it 'has repositories represented as a hash' do
    expect(described_class.repositories).to eq({})
  end

  it 'can register something as a repository' do
    described_class.register(:wat_repo, 'wat')
    expect(described_class.repositories[:wat_repo]).to eq 'wat'
  end

  it 'can use a key as a dynamic method to look up a repository' do
    described_class.register(:wat_repo, 'wat')
    expect(described_class.wat_repo).to eq 'wat'
  end

  it "returns a 'repo not found' error if called with an unknown key" do
    expect { described_class.not_found_repo } .to raise_error
  end
end
