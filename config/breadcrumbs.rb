# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).

crumb :root do
  link 'Home', root_path
end

crumb :postal_code_search_search do
  link '郵便番号検索', api_postal_code_search_search_path
  parent :root
end

crumb :comic_index do
  link '漫画一覧', comics_path
  parent :root
end

crumb :comic_new do
  link '漫画投稿', new_comic_path
  parent :comic_index
end

crumb :comic_edit do
  link '漫画編集', edit_comic_path
  parent :comic_index
end

crumb :google_map do
  link 'googleマップ', google_map_posts_path
  parent :root
end

crumb :tweet_index do
  link 'ツイート一覧', tweets_path
  parent :root
end

crumb :tweet_new do
  link 'ツイート投稿', new_tweet_path
  parent :tweet_index
end

crumb :tweet_edit do
  link 'ツイート編集', edit_tweet_path
  parent :tweet_index
end

crumb :area_index do
  link 'エリア一覧', areas_path
  parent :root
end

crumb :area_new do
  link 'エリア投稿', new_area_path
  parent :area_index
end

crumb :area_show do |area|
  link 'エリア詳細', area_path(area)
  parent :area_index
end

crumb :area_edit do |area|
  link 'エリア編集', edit_area_path(area)
  parent :area_show, area
end

crumb :area_food_new do |area|
  link '食品登録', new_area_foods_path(area)
  parent :area_show, area
end

crumb :area_food_edit do |area|
  link '食品編集', edit_area_foods_path(area)
  parent :area_show, area
end
