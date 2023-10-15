require 'rails_helper'

RSpec.describe Comic, type: :model do
  describe 'コミック登録' do
    let(:comic) { FactoryBot.build(:comic) }

    context 'コミックが登録できる時' do
      it 'すべての情報があれば登録できる' do
        expect(comic).to be_valid
      end
    end

    context 'コミックが登録できない時' do
      it 'タイトル(title)が空だと登録できない' do
        comic.title = ''
        comic.valid?
        expect(comic.errors.full_messages).to include('タイトル を入力してください')
      end

      it '著者(author)が空だと登録できない' do
        comic.author = ''
        comic.valid?
        expect(comic.errors.full_messages).to include('著者 を入力してください')
      end
    end
  end
end
