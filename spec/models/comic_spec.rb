require 'rails_helper'

RSpec.describe Comic, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  describe 'コミック登録' do
    let(:comic) { FactoryBot.build(:comic) }

    context 'コミックが登録できる時' do
      it 'すべての情報があれば登録できる' do
        expect(comic).to be_valid
      end
    end

    context 'コミックが登録できない時' do
      it 'titleが空だと登録できない' do
        comic.title = ''
        comic.valid?
        expect(comic.errors.full_messages).to include("Title can't be blank")
      end

      it 'authorが空だと登録できない' do
        comic.author = ''
        comic.valid?
        expect(comic.errors.full_messages).to include("Author can't be blank")
      end
    end
  end
end
