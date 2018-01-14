class ValidationsController < ApplicationController
  before_filter :load_validation, only: [:destroy, :run]

  def index
    @validations = Validation.all.paginate(paginate_params).order(sort_params)
  end

  def new
    @validation = Validation.new
  end

  def create
    @validation = Validation.new(validation_params)
    if @validation.save
      flash[:success] = 'Validation was successfully created'
      redirect_to validations_path
    end
  end

  def destroy
    if @validation.destroy
      flash[:success] = 'Validation was successfully removed'
      redirect_to validations_path
    end
  end

  def run
    @validation.validate
    redirect_to validation_folds_path(validation_id: @validation.id)
  end

  ####################
  # OLD implementation
  def _run
    @validation.update_attributes(status: :running)
    # sum = 0
    # max = 0
    dataset = Mashup.dataset(2, 0)
    # dataset = Mashup.dataset(2, 0).limit(289)
    subset_size = dataset.size.size / @validation.k
    # dataset = Mashup.dataset(2, 0).where('mashups.id <= 2142')
    # subset_size = 1 ###

    dataset.find_in_batches(batch_size: subset_size).with_index do |subset, index|
      # byebug
      # score = validate_set(subset, @validation.list_size)
      # sum += score
      result = validate_set(subset, @validation.list_size)
      score = result[:score]
      # sum += score
      # max += result[:max]
      @validation.folds.create(run: index, set_size: subset_size, score: score, max_score: result[:max])
      break if index == 0 ###
    end
    @validation.update_attributes(status: :completed)
    redirect_to validation_folds_path(validation_id: @validation.id)
  end

  def validate_set(set, top)
    iset = set.first(5)
    score = iset.reduce(0.0) do |sum, item|
      # predictable_item = item.random_element # Sacar una API aleatoriamente del mashup
      predictable_item = item.apis.first # Sacar la primera API del mashup
      test_items = item.apis[1..-1].map(&:id) # Resto de las APIs
      # recommendation_list = predictable_item.recommendation_list(top)
      byebug
      recommendation_list = Api.co_api_scores(test_items, top, set.map(&:id))
      sum + score_item(predictable_item.id, recommendation_list)
    end
    # max = max_item_score * set.size
    # {score: score, max: max}
    {score: score/set.size, max: 1}
  end

  def score_item(item, list)
    send(@validation.metric, item, list)
  end

  def max_item_score
    send("max_#{@validation.metric}")
  end

  def hit_rate(item, list)
    list.include?(item) ? 1 : 0
  end

  def max_hit_rate
    1
  end

  def half_life(item, list)
    # Implementar
    p 'hals_life metric called'
  end

  def max_half_life
    # Implementar
    p 'hals_life max score called'
  end

  # def cross_validation(k = 10, min = 2, max = 0, top = 10)
  #   results = []
  #   dataset = get_dataset(min, max)
  #   subset_size = dataset.size / k
  #
  #   dataset.find_in_batches(batch_size: subset_size) do |subset|
  #     results.add(validate_set(subset, top));
  #   end
  #
  #   # Promediar resultados
  #   avg = 0
  #   results.each do |score|
  #     avg += score
  #   end
  #
  #   avg / results.size
  #   # System.out.println("Scores average [Top " + topListSize + "]: " + avg);
  #   # avg
  # end

  # def get_dataset(min = 0, max = 0)
  #   return Mashup.all if min <= 0 && max <= 0
  #   mashups = Mashup.joins(:apis).group(:id)
  #   mashups = mashups.having('COUNT(apis.id) >= ?', min) if min > 0
  #   mashups = mashups.having('COUNT(apis.id) <= ?', max) if max > 0
  #   mashups
  # end

  private

  def load_validation
    @validation = Validation.find(params[:id])
  end

  def validation_params
    params.require(:validation).permit(:name, :k, :list_size, :metric)
  end
end