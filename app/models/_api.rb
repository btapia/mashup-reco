class Api < ActiveRecord::Base
  has_many :mashup_apis
  has_many :mashups, through: :mashup_apis
  has_many :api_tags
  has_many :tags, through: :api_tags

  # def co_apis
  #   mashup_ids = mashups.pluck(:id)
  #   Api.joins(:mashups).where('mashups.id IN (?)', mashup_ids).where.not(id: id).distinct
  # end

  # def co_api_scores(size = nil)
  #   mashup_ids = mashups.pluck(:id)
  #   scores = MashupApi.where(mashup_id: mashup_ids).where.not(api_id: id).group(:api_id).order('count_mashup_id DESC').limit(size).count(:mashup_id)
  #   scores.transform_values { |v| v / mashup_ids.size.to_f }
  # end

  # def recommendation_list(size = nil)
  #   co_api_scores(size).keys
  # end

  # Retorna un arreglo de CoAPI IDs ordenados descendentemente por el numero de mashups en que aparecen junto a las APIs
  # pasadas como parametro. Opcionalmente, se retorna la lista top N (limit).
  def self.co_apis(api_ids, limit = nil)
    mashup_ids = MashupApi.where(api_id: api_ids).group(:mashup_id).having('count(*) = ?', api_ids.size).pluck(:mashup_id)
    MashupApi.where(mashup_id: mashup_ids).where.not(api_id: api_ids).group(:api_id).order('count_all DESC').limit(limit).count.keys
  end

  # MISMOS RESULTADOS QUE JAVA
  # Para un grupo de APIs (api_ids) calcula sus CoAPIs y puntajes.
  # Opcionalmente, calcula solo las top N (limit), ordenadas por su puntaje descendentemente.
  def self.co_api_scores(api_ids, limit = nil, excluded_ids = nil, level = nil)
    level = api_ids.size unless level
    # Mashups que contienen a todas las APIs (a la vez) pasadas como parametro
    mashup_set = MashupApi.where.not(mashup_id: excluded_ids)
    mashup_ids = mashup_set.where(api_id: api_ids).group(:mashup_id).having('count(*) = ?', level).pluck(:mashup_id)
    # Hash con el ID de la CoAPI y el numero de mashups en la que aparece
    scores = MashupApi
                 .where(mashup_id: mashup_ids)
                 .where.not(api_id: api_ids)
                 .group(:api_id)
                 .order('count_all DESC, api_id')
                 .limit(limit)
                 .count
    scores.transform_values { |v| v / mashup_ids.size.to_f }
  end

  # Para un grupo de APIs (api_ids) calcula sus CoAPIs y puntajes.
  # Opcionalmente, calcula solo las top N (limit), ordenadas por su puntaje descendentemente.
  def self.co_api_scores_1(api_ids, limit = nil, excluded_ids = nil)
    # def self.co_api_scores(api_ids, limit = nil)
    # Mashups que contienen a todas las APIs (a la vez) pasadas como parametro
    mashup_ids = MashupApi.where(api_id: api_ids).where.not(mashup_id: excluded_ids).group(:mashup_id).having('count(*) = ?', api_ids.size).pluck(:mashup_id)
    # Hash con el ID de la CoAPI y el numero de mashups en la que aparece
    scores = MashupApi.where(mashup_id: mashup_ids).where.not(api_id: api_ids).group(:api_id).order('count_all DESC').limit(limit).count
    # p MashupApi.where(mashup_id: mashup_ids).where.not(api_id: api_ids).group(:api_id).order('count_all DESC').limit(limit).to_sql
    # byebug
    scores.transform_values { |v| v / mashup_ids.size.to_f }
  end

  def self.search(query)
    includes(:tags).references(:tags).where('apis.name LIKE ? OR tags.name LIKE ?', "%#{query}%", "%#{query}%")
  end
end

# Mashups que incluyen las apis seleccionadas
# Mashup.includes(:apis).where(apis: {id: [1,191]}).group(:id).having('count(*) = ?', 2).pluck(:mashup_id)
# Mashup.includes(:apis).where(apis: {id: [1,191]}).pluck(:id)
# MashupApi.where(api_id: [1,191]).pluck(:mashup_id)
# MashupApi.where(api_id: [1,191]).group(:mashup_id).having('count(*) = ?', 2).pluck(:mashup_id) # Mas eficiente

# Contar las veces que las CoAPIs aparecen en esos mashups. Las otras APIs de esos mashups que aparecen junto a [1,191] y en cuantos de esos mashups estan
# MashupApi.where(mashup_id: mashup_ids).where.not(api_id: [1,191]).group(:api_id).count

# Apis que pertenecen a el o los mashups seleccionados
# Api.includes(:mashups).where(mashups: {id: 2345})

# SELECT api_id, COUNT(*) FROM mashup_apis WHERE mashup_id IN (2345,2351,4235,6284,6740,6913) AND api_id NOT IN (191) GROUP BY api_id
# SELECT `mashup_apis`.* FROM `mashup_apis` WHERE `mashup_apis`.`mashup_id` = 8323 AND (`mashup_apis`.`api_id` != 13177) GROUP BY `mashup_apis`.`api_id`