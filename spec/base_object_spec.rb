require 'base_object'

describe BaseObject do
  let(:undefined_error) { described_class::UndefinedAttributes }

  context 'Inheriting class without attributes' do
    it 'raises an error if inheriting class does not define attr_accessors method' do
      class MockWithoutAttributes < BaseObject; end
      expect{ MockWithoutAttributes.new }.to raise_error undefined_error
    end
  end

  context 'Inheriting class with defined attr_accessors' do
    class MockObject < BaseObject
      def attr_accessors
        [:wip, :wat]
      end
    end

    let(:mock) { MockObject.new }
    let(:combined_attributes) do
      BaseObject::BASE_ATTRIBUTES + MockObject.new.attr_accessors
    end

    describe '#initialize behavior' do
      it 'initializes an object with defined attr_accessors and base_attributes' do
        expect(mock.attrs).to match(combined_attributes)
      end

      it 'initializes an object with a set of nil attributes' do
        combined_attributes.each do |attr|
          expect(mock.send(attr)).to be_nil
        end
      end
    end

    describe 'setters and getters' do
      it 'allows you to set and get an attribute' do
        mock.wip = "this"
        expect(mock.wip).to eq "this"
      end

      it 'raises an UndefinedAttribute error if setting an unspecified attributes' do
        expect{ mock.no_attr = 'oops' }.to raise_error(undefined_error)
      end

      it 'raises an UndefinedAttribute error if getting an unspecified attributes' do
        expect{ mock.no_attr }.to raise_error(undefined_error)
      end
    end

    describe '#attributes' do
      it 'provides all the attributes and their values as a hash' do
        mock.wip = 'WIP'
        mock.wat = 'woot'
        expect(mock.attributes).to match( { wip: 'WIP',
                                            wat: 'woot',
                                            id: nil } )
      end
    end

    describe '#update' do
      it 'can update an attribute as a key-value pair' do
        mock.update(wip: 'new_value')
        expect(mock.wip).to eq 'new_value'
      end

      it 'raises error if sending in an attribute key that does not exist' do
        expect{ mock.update(fake_attr: 'new_value') }.to raise_error(undefined_error)
      end
    end
  end
end
