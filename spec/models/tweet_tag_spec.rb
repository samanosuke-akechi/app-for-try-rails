require 'rails_helper'

RSpec.describe TweetTag, type: :model do
  describe 'ツイートタグ登録' do
    let(:tweet_tag) { FactoryBot.build(:tweet_tag) }

    context 'ツイートタグが登録できるとき' do
      it 'すべての情報があれば登録できる' do
        expect(tweet_tag).to be_valid
      end
    end

    context 'ツイートタグが登録できないとき' do
      it 'タグ(name)が空だと登録できない' do
        tweet_tag.name = nil
        tweet_tag.valid?
        expect(tweet_tag.errors.full_messages).to include('タグ を入力してください')
      end
    end
  end
end
