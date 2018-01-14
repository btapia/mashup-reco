class ApiTag < ActiveRecord::Base
    belongs_to :api, foreign_key: :api_id
    belongs_to :tag, foreign_key: :tag_id
end
