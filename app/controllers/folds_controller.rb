class FoldsController < ApplicationController
  before_filter :load_validation

  def index
    @folds = @cross_validation.folds.paginate(paginate_params).order(sort_params(:run))
  end

  private

  def load_validation
    @cross_validation = Validation.where(id: params[:validation_id]).take
    raise StandardError unless @cross_validation
  end
end
