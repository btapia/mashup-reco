module Helpers
  def calculate_coapis(apis, mashups)
    scores = {}
    mashup_count = 0.0
    mashups.each do |mashup|
      api_set = mashup.apis.pluck(:id)
      if (apis - api_set).empty? # api_set contains apis?
        mashup_count += 1
        other_apis = api_set - apis
        ss = Hash[other_apis.map { |v| [v, 1] }]
        scores.merge!(ss) { |_, o, n| o + n }
      end
    end
    scores.transform_values { |v| v / mashup_count }
  end
end
