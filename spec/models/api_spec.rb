require 'rails_helper'

describe Api do
  it 'Has a valid factory' do
    expect(build(:api)).to be_valid
  end

  describe '.search' do
    it 'finds an API' do
      create(:api, name: 'API super pulentosa')
      expect(described_class.search('super').size).to eq(1)
    end
  end
end
