FactoryBot.define do
  factory :food do
    name { Faker::Food.dish }
    price { 2500 }

    association :area
  end
end
