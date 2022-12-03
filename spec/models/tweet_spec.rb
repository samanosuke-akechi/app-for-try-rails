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
      it 'titleが空だと登録できない' do
        tweet.title = ''
        tweet.valid?
        expect(tweet.errors.full_messages).to include("Title can't be blank")
      end

      it 'textが空だと登録できない' do
        tweet.text = ''
        tweet.valid?
        expect(tweet.errors.full_messages).to include("Text can't be blank")
      end
    end
  end
end
