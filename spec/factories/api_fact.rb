FactoryGirl.define do
  factory :api, class: Api do
    sequence(:name) { |n| "Example API #{n}" }
    sequence(:war)
  end
end
