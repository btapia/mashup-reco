FactoryGirl.define do
  factory :mashup, class: Mashup do
    sequence(:name) { |n| "Example Mashup #{n}" }
  end
end
