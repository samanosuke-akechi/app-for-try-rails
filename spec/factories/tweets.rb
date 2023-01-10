FactoryBot.define do
  factory :tweet do
    title { Faker::Lorem.characters(number: 10) }
    text { Faker::Lorem.characters(number: 10) }
  end
end
