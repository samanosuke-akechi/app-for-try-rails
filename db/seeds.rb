# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

num = 1

100.times do |data|
  Post.create!(
    title: "タイトル#{num}",
    text: SecureRandom.urlsafe_base64(200)
  )
  num += 1
end

item_hundler = 1
user_hundler = 1
time_hundler = 10
num_sold_hundler = 12

15.times do
  SalesManagement.create!(
    item_id: item_hundler,
    user_id: user_hundler,
    sales_date: DateTime.new(2021, 1, time_hundler + item_hundler),
    number_sold: num_sold_hundler / item_hundler
  )
  if item_hundler == 3
    item_hundler = 0
    user_hundler = 0
    time_hundler += 1
    num_sold_hundler += 6
  end
  item_hundler += 1
  user_hundler += 1
end
