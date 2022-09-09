require 'rails_helper'

RSpec.describe 'Comics', type: :request do
  before do
    @comic = Comic.create(title: 'タイトル', author: '著者')
  end

  describe 'GET /comics #index' do
    it 'indexアクションにリクエストすると正常にレスポンスが帰ってくる' do
      get comics_path
      expect(response).to have_http_status(200)
    end

    it 'indexアクションにリクエストするとレスポンスに登録済みのコミックのタイトルが存在する' do
      get comics_path
      expect(response.body).to include(@comic.title)
    end

    it 'indexアクションにリクエストするとレスポンスに登録済みのコミックの著者名が存在する' do
      get comics_path
      expect(response.body).to include(@comic.author)
    end

    it 'indexアクションにリクエストするとレスポンスに漫画の新規登録へのリンクが存在する' do
      get comics_path
      expect(response.body).to include(new_comic_path)
    end
  end
end
