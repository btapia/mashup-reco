class Api < ActiveRecord::Base
  has_many :mashup_apis
  has_many :mashups, through: :mashup_apis
  has_many :api_tags
  has_many :tags, through: :api_tags

  # Para un grupo de APIs (api_ids) calcula sus CoAPIs y puntajes.
  # Opcionalmente, calcula solo las top N (limit), ordenadas por su puntaje descendentemente.
  def self.co_api_scores(api_ids, limit = nil, excluded_ids = nil, level = nil)
    combined_scores = {}
    n = api_ids.size
    level = n unless level
    weight_sum = n.downto(level).sum.to_f

    # NO FUNCIONA CON TODOS LOS NIVELES
    n.downto(level).each do |count|
      # Mashups que contienen a todas las APIs (a la vez) pasadas como parametro
      mashup_set = MashupApi.where.not(mashup_id: excluded_ids)
      mashup_ids = mashup_set.where(api_id: api_ids).group(:mashup_id).having('COUNT(*) = ?', count).pluck(:mashup_id)
      # Hash con el ID de la CoAPI y el numero de mashups en la que aparece
      scores = MashupApi#.joins(:api)
                   .where(mashup_id: mashup_ids)
                   .where.not(api_id: api_ids)
                   .group(:api_id)
                   .order('count_all DESC, api_id') # .order('count_all DESC, apis.war DESC')
                   .limit(limit)
                   .count
      weight = count / weight_sum
      scores.transform_values! { |v| weight * v / mashup_ids.size.to_f }
      combined_scores.merge!(scores) { |_, o, m| o + m }
      # byebug
    end
    combined_scores
  end

  def self.search(query)
    includes(:tags).references(:tags).where('apis.name LIKE ? OR tags.name LIKE ?', "%#{query}%", "%#{query}%")
  end
end
