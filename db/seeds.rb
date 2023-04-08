# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

num = 1

100.times do |data|
  post = Post.find_or_initialize_by(
    title: "タイトル#{num}"
  )
  next if post.persisted?

  post.text = SecureRandom.urlsafe_base64(200)
  post.save
  num += 1
end

num = 1
file_path = 'spec/fixtures/300x300.png'

5.times do
  tweet = Tweet.find_or_initialize_by(
    title: "ツイート#{num}",
    text: "ツイート#{num}のテキスト\nツイート#{num}のテキスト\nツイート#{num}のテキスト"
  )
  next if tweet.persisted?

  tweet.save
  tweet_image = TweetImage.new(tweet: tweet)
  tweet_image.storage_file.attach(io: File.open(file_path), filename: File.basename(file_path))
  tweet_image.save
  num += 1
end

tag_attributes = [
  { name: '高級' },
  { name: 'お買い得' },
  { name: '限定' }
]
tag_attributes.each do |tag_attribute|
  Tag.find_or_create_by(tag_attribute)
end
