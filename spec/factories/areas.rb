FactoryBot.define do
  factory :area do
    name { Faker::Address.country }
  end
end
