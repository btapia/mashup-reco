class Tag < ActiveRecord::Base
  has_many :apis, through: :apis_tags
  has_many :mashups, through: :mashups_tags
end
