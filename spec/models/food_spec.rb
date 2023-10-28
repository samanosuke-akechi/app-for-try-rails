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
        expect(food.errors.full_messages).to include('地域 を入力してください')
      end

      it '食品名(name)がないと登録できない' do
        food.name = ''
        food.valid?
        expect(food.errors.full_messages).to include('食品名 を入力してください')
      end

      it '価格(price)がないと登録できない' do
        food.price = nil
        food.valid?
        expect(food.errors.full_messages).to include('価格 を入力してください')
      end
    end
  end
end
