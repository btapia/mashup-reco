require 'rails_helper'

describe ApisController do
  before(:all) do
    @apis = create_list(:api, 5)
  end

  describe '#index' do
    it 'lists all APIs' do
      get :index
      expect(assigns(:apis)).to eq @apis.sort_by(&:war).reverse
    end

    it 'filters query' do
      api = @apis.sample
      api.update!(name: 'API de prueba')
      get :index, q: 'prueba'
      expect(assigns(:apis)).to match_array([api])
    end

    it 'loads recommendations' do

    end
  end
end
