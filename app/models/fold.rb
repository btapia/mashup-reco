class Fold < ActiveRecord::Base
  belongs_to :validation, inverse_of: :folds

  after_save :update_total
  after_destroy :update_total

  def update_total
    validation.update_score
  end
end