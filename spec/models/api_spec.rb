require 'rails_helper'
require 'support/helpers'

RSpec.configure do |c|
  c.include Helpers
end

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

    it '.calculate_scores' do
      (1..@apis.size).each do |i|
        @apis.each_slice(i) do |apis|
          api_ids = apis.map(&:id)
          test_score = Api.calculate_scores(MashupApi, api_ids)
          calc_score = calculate_coapis(api_ids, @mashups)
          puts "#{api_ids}: #{test_score}"
          expect(test_score).to eq(calc_score)
        end
      end
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
