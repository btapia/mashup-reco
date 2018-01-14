FactoryGirl.define do
  factory :api, class: Api do
    name Faker::Name.name
  end
end
