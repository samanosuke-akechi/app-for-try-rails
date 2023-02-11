require 'rails_helper'

RSpec.describe TweetImage, type: :model do
  describe 'ツイート画像登録' do
    let(:tweet_image) { FactoryBot.build(:tweet_image) }

    context 'ツイート画像が登録できるとき' do
      it 'すべての情報があれば登録できる' do
        expect(tweet_image).to be_valid
      end
    end

    context 'ツイート画像が登録できないとき' do
      it 'ツイートに紐づかないと登録できない' do
        tweet_image.tweet = nil
        tweet_image.valid?
        expect(tweet_image.errors.full_messages).to include('Tweet must exist')
      end

      it 'storage_fileがないと登録できない' do
        tweet_image.storage_file = nil
        tweet_image.valid?
        expect(tweet_image.errors.full_messages).to include('Storage file must exist')
      end
    end
  end
end
