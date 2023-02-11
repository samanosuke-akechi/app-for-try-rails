FactoryBot.define do
  factory :tweet_tag do
    name { Faker::Lorem.characters(number: 10) }

    association :tweet
  end
end
