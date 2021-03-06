require 'rails_helper'
require 'feature/collection'

describe Feature::Collection do

  def new_model(params = {})
    Feature::Model.new params
  end

  def new_collection
    Feature::Collection.new
  end

  context 'basic object creation' do

    before(:each) { @obj = new_collection }

    it 'works' do
      expect(@obj).not_to be_nil
    end

    describe 'object methods' do
      specify { expect(@obj).to respond_to :count       }
      specify { expect(@obj).to respond_to :to_h        }
      specify { expect(@obj).to respond_to :to_a        }
      specify { expect(@obj).to respond_to :create      }
    end

    context 'with hash params' do
      def valid_params
        {
            label:          'x.xyz',
            name:           'XYZ',
            author:         'LICA',
            description:    'TBD',
            dependencies:   [],
            version:        '1.0'
        }
      end
      it 'works with one hash' do
        @obj = new_collection.add_data({a: valid_params})
        expect(@obj.count).to eq(1)
        expect(@obj).not_to be_nil
      end
      it 'works with two hashes' do
        @obj = new_collection.add_data({a: valid_params, b: valid_params.merge({label: 'asdf'})})
        expect(@obj.count).to eq(2)
        expect(@obj).not_to be_nil
      end
    end

  end

  describe '.[]' do
    before(:each) do
      @obj1 = Feature::Model.new
      @obj2 = Feature::Model.new({label: 'asdf'})
      @col  = new_collection.add_obj @obj1, @obj2
    end

    it 'returns the right object' do
      expect(@col[@obj1.id]).to eq(@obj1)
    end

    it 'returns nil with an invalid key' do
      expect(@col['unknown']).to eq(nil)
    end

  end

  describe '.count' do

    before(:each) { @col = new_collection }

    context 'with no objects' do
      specify { expect(@col.count).to eq(0) }
    end

    context 'with one object' do
      it 'returns count of one' do
        @col.add_obj(new_model)
        expect(@col.count).to eq(1)
      end
    end

    context 'with two objects' do
      it 'returns count of two' do
        @col.add_obj(new_model, new_model({label: 'asdf'}))
        expect(@col.count).to eq(2)
      end
    end

    context 'after destroying an object' do
      it 'returns count of one' do
        mdl1 = new_model
        mdl2 = new_model
        @col.add_obj mdl1, mdl2
        @col.destroy mdl1
        expect(@col.count).to eq(1)
      end
    end

  end

  describe '.find' do

    before(:each) { @col = new_collection }

    context 'with no objects' do
      specify {expect(@col.find('asdf')).to be_nil}
    end

    context 'with two objects' do
      context 'when a key hits' do
        it 'returns an object' do
          mdl1 = new_model
          @col.add_obj mdl1, new_model({label: 'qwer'})
          expect(@col.find(mdl1.id)).to eq(mdl1)
        end
      end
      context 'when a key misses' do
        it 'returns nil' do
          @col.add_obj new_model, new_model
          expect(@col.find('asdf')).to be_nil
        end
      end
    end
  end

  describe '#to_a' do
    context 'with no objects' do
      specify {expect(new_collection.to_a).to be_a Array }
      specify {expect(new_collection.to_a.count).to eq(0)}
    end

    context 'with two objects' do
      before(:each) { @col = new_collection.add_obj new_model, new_model({label: 'qwer'})}
      it 'generates a valid array' do
        expect(@col.to_a).to be_an Array
        expect(@col.to_a.first).to be_a Feature::Model
        expect(@col.to_a.length).to eq(2)
      end
    end
  end

  describe '#to_h' do
    context 'with no objects' do
      specify {expect(new_collection.to_h).to be_a Hash }
      specify {expect(new_collection.to_h.count).to eq(0)}
    end

    context 'with two objects' do
      before(:each) { @col = new_collection.add_obj new_model, new_model({label: 'asdf'})}
      it 'generates a valid hash' do
        result = @col.to_h
        expect(result).to be_a Hash
        expect(result[result.keys.first]).to be_a Feature::Model
        expect(result.length).to eq(2)
      end
    end
  end

  describe '#to_data' do
    context 'with no objects' do
      specify {expect(new_collection.to_data).to be_a Hash }
      specify {expect(new_collection.to_data.count).to eq(0)}
    end

    context 'with two objects' do
      before(:each) { @col = new_collection.add_obj new_model, new_model({label: 'qwer'})}
      it 'generates a valid hash' do
        result = @col.to_data
        expect(result).to be_a Hash
        expect(result[result.keys.first]).to be_a Hash
        expect(result.length).to eq(2)
      end
    end

  end

end