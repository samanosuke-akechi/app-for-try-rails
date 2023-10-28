require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe 'ツイート登録' do
    let(:tweet) { FactoryBot.build(:tweet) }

    context 'ツイートが登録できるとき' do
      it 'すべての情報があれば登録できる' do
        expect(tweet).to be_valid
      end
    end

    context 'ツイートが登録できないとき' do
      it 'タイトル(title)が空だと登録できない' do
        tweet.title = ''
        tweet.valid?
        expect(tweet.errors.full_messages).to include('タイトル を入力してください')
      end

      it '本文(text)が空だと登録できない' do
        tweet.text = ''
        tweet.valid?
        expect(tweet.errors.full_messages).to include('本文 を入力してください')
      end
    end
  end
end
