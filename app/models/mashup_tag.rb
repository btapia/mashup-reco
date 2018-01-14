class MashupTag < ActiveRecord::Base
    belongs_to :mashup, foreign_key: :mashup_id
    belongs_to :tag, foreign_key: :tag_id
end
