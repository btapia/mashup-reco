class MashupsController < ApplicationController
  def index
    @mashups = Mashup.includes(:apis, :tags).paginate(paginate_params).order(sort_params(:published))
  end
end
