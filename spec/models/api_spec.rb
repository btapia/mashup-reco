require 'rails_helper'

describe Api do
  it 'Has a valid factory' do
    expect(build(:api)).to be_valid
  end

  describe '.search' do
    it 'finds an API' do
      create(:api, name: 'API super pulentosa')
      expect(described_class.search('super').size).to eq(1)
      expect(described_class.search('otro').size).to eq(0)
    end
  end

  describe '.co_api_scores' do
    before(:all) do
      @mashups = create_list(:mashup, 3)
      @apis = create_list(:api, 8)
      @mashups[0].apis = @apis[0..4]
      @mashups[1].apis = @apis[2..6]
      @mashups[2].apis = [@apis[2]] + @apis[5..9]
    end

    it 'calculates co-APIs' do

    end
  end
end
