require 'rails_helper'

RSpec.describe Food, type: :model do
  let(:food) { FactoryBot.build(:food) }

  describe '食べ物登録' do
    context '食べ物が登録できるとき' do
      it 'すべての情報があれば登録できるとき' do
        expect(food).to be_valid
      end
    end

    context '食べ物が登録できないとき' do
      it 'areaがないと登録できない' do
        food.area = nil
        food.valid?
        expect(food.errors.full_messages).to include('Area must exist')
      end

      it 'nameがないと登録できない' do
        food.name = ''
        food.valid?
        expect(food.errors.full_messages).to include("Name can't be blank")
      end

      it 'priceがないと登録できない' do
        food.price = nil
        food.valid?
        expect(food.errors.full_messages).to include("Price can't be blank")
      end
    end
  end
end
