class Mashup < ActiveRecord::Base
  has_many :mashup_apis
  has_many :apis, through: :mashup_apis
  has_many :mashup_tags
  has_many :tags, through: :mashup_tags

  def random_element
    apis.sample
  end

  def self.dataset(min = 0, max = 0)
    return Mashup.all if min <= 0 && max <= 0
    # mashups = Mashup.includes(:apis).references(:apis).group(:id)
    mashups = Mashup.joins(:apis).group(:id)
    mashups = mashups.having('COUNT(apis.id) >= ?', min) if min > 0
    mashups = mashups.having('COUNT(apis.id) <= ?', max) if max > 0
    mashups
  end

  def self.dataset_old(min = 0, max = 0)
    return Mashup.all if min <= 0 && max <= 0
    mashups = MashupApi.group(:mashup_id)
    mashups = mashups.having('COUNT(api_id) >= ?', min) if min > 0
    mashups = mashups.having('COUNT(api_id) <= ?', max) if max > 0
    mashups
    # Mashup.where(id: mashups.pluck(:mashup_id))
  end
end
