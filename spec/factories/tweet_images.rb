FactoryBot.define do
  factory :tweet_image do
    association :tweet

    after(:build) do |tweet_image|
      file_path = 'spec/fixtures/300x300.png'
      tweet_image.storage_file.attach(io: File.open(file_path), filename: File.basename(file_path))
    end
  end
end
