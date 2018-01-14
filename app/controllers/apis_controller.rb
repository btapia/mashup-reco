class ApisController < ApplicationController
  # before_filter :load_selected

  def index
    # byebug
    @apis = Api
    if params[:q]
      @apis = @apis.search(params[:q])
    end
    @apis = @apis.includes(:tags).paginate(paginate_params).order(sort_params(:war))
    load_recommendations
  end

  def load_recommendations
    if params[:sel]
      ids = params[:sel].split(',').map(&:to_i)
      @selected_apis = Api.where(id: ids)
      scores = Api.co_api_scores(ids, 10)
      names = Api.where(id: scores.keys).pluck(:id, :name).to_h
      # @recomendation_list = scores.each { |k, v| co_apis.push([k, names[k], v]) }
      @recomendation_list = scores.merge(names) { |_, o, n| [n, o] }
    end
  end

  # def select
  #   @selected_apis |= [params[:id].to_i]
  #   redirect_to apis_path(request.query_parameters)
  # end

  # private

  # def load_selected
  #   @selected_apis ||= []
  # end
end
