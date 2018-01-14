class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def paginate_params
    page = params[:page].to_i > 0 ? params[:page] : 1
    per_page = params[:per_page].to_i > 0 ? [params[:per_page].to_i, 50].min : 13
    {page: page, per_page: per_page}
  end

  def sort_params(sort_by = :id)
    sort_by = params[:sort_by] if params[:sort_by].present?
    ordering = params[:order]&.downcase == 'asc' ? :asc : :desc
    {sort_by => ordering}
  end
end
