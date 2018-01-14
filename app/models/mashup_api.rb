class MashupApi < ActiveRecord::Base
    belongs_to :api, foreign_key: :api_id
    belongs_to :mashup, foreign_key: :mashup_id
end
