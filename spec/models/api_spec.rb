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
      @co_api_scores = [
          {2 => 1, 3 => 1, 4 => 1, 5 => 1},
          {1 => 1, 3 => 1, 4 => 1, 5 => 1},
          {1 => 1/3.0, 2 => 1/3.0, 4 => 2/3.0, 5 => 2/3.0, 6 => 2/3.0, 7 => 2/3.0, 8 => 1/3.0},
          {1 => 1/2.0, 2 => 1/2.0, 3 => 1, 5 => 1, 6 => 1/2.0, 7 => 1/2.0},
          {1 => 1/2.0, 2 => 1/2.0, 3 => 1, 4 => 1, 6 => 1/2.0, 7 => 1/2.0},
          {3 => 1, 4 => 1/2.0, 5 => 1/2.0, 7 => 1, 8 => 1/2.0},
          {3 => 1, 4 => 1/2.0, 5 => 1/2.0, 6 => 1, 8 => 1/2.0},
          {3 => 1, 6 => 1, 7 => 1}
      ]
    end

    it 'coapis' do
      api_ids = [1]
      count = api_ids.size
      mashup_set = MashupApi
      mashup_ids = mashup_set.where(api_id: api_ids).group(:mashup_id).having('COUNT(*) = ?', count).pluck(:mashup_id)
      # byebug
    end

    it 'calculates co-APIs' do
      # byebug
      results = {}
      @apis.each do |api|
        results[api.id] = []
        @mashups.each do |m|
          if m.apis.pluck(:id).include?(api.id)
            # results[api.id].push(*m.apis.where.not(id: api.id).pluck(:id))
            results[api.id].push(m.apis.where.not(id: api.id).pluck(:id))
          end
        end
      end
      # ap results
      @res = {}
      results.each do |k, v|
        n = v.size.to_f
        @res[k] = v.flatten.reduce(Hash.new(0)) { |h, i| h[i] += 1/n; h }
      end
      @apis.each_with_index do |api, i|
        # expect(described_class.co_api_scores([api])).to eq(@co_api_scores[i])
        expect(described_class.co_api_scores([api])).to eq(@res[api.id])
      end
    end
  end
end
