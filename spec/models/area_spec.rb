require 'rails_helper'

RSpec.describe Area, type: :model do
  describe 'エリア登録' do
    let(:area) { FactoryBot.build(:area) }

    context 'エリアが登録できるとき' do
      it 'すべての情報があれば登録できる' do
        expect(area).to be_valid
      end
    end

    context 'エリアが登録できないとき' do
      it '地域名(name)がないと登録できない' do
        area.name = ''
        area.valid?
        expect(area.errors.full_messages).to include('地域名 を入力してください')
      end
    end
  end
end
