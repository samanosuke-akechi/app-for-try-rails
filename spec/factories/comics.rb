FactoryBot.define do
  factory :comic do
    title { Faker::Book.title }
    author { Faker::Book.author }
  end
end
