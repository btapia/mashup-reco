class Validation < ActiveRecord::Base
  has_many :folds, inverse_of: :validation, dependent: :destroy

  enum metric: [:hit_rate, :half_life]
  enum status: [:created, :running, :completed]

  def update_score
    score = folds.average(:score)
    update_column(:score, score)
    # max_score = folds.average(:max_score)
    # update_column(:max_score, max_score)
  end

  def validate
    set_status(:running)
    dataset = Mashup.dataset(2, 0)
    subset_size = dataset.size.size / k

    dataset.find_in_batches(batch_size: subset_size).with_index do |subset, index|
      score = validate_set(subset, list_size)
      folds.create(run: index, set_size: subset_size, score: score)
      break if index == 0 ### k-1 para todos, 0 para una iteracion
    end
    set_status(:completed)
  end

  def validate_set(set, top)
    # iset = set
    iset = set.first(5) ###
    score = iset.reduce(0.0) do |sum, item|
      api_ids = item.apis.pluck(:id)
      # predictable_item = item.random_element # Sacar una API aleatoriamente del mashup
      predictable_item = api_ids.first # Sacar la primera API del mashup
      test_items = api_ids[1..-1] # Resto de las APIs
      level = test_items.size-1 # test_items.size (considera todas las APIs restantes, calcula una vez), 1 (usa todos los subconjuntos de las APIs restantes, calcula n veces)
      recommendation_list = Api.co_api_scores(test_items, top, set.map(&:id), level)
      # byebug
      sum + score_item(predictable_item, recommendation_list)
    end
    score / set.size
  end

  def score_item(item, list)
    send(metric, item, list)
  end

  def hit_rate(item, list)
    list.include?(item) ? 1 : 0
  end

  def half_life(item, list)
    # Implementar
    p 'hals_life metric called'
  end

  private

  def set_status(status)
    update_attributes(status: status)
  end
end