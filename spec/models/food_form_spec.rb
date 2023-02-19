require 'rails_helper'

RSpec.describe FoodForm, type: :model do
  let(:food_form) { FactoryBot.build(:food_form) }

  describe 'FoodForm登録' do
    context 'FoodFormが登録できるとき' do
      it 'すべての情報があれば登録できる' do
        expect(food_form.save).to eq true
      end
    end

    context 'FoodFormが登録できないとき' do
      it 'consentがfalseだと登録できない' do
        food_form.consent = false
        food_form.valid?
        expect(food_form.errors.full_messages).to include('Consent must be accepted')
      end

      it 'foodsのうち一つのnameが空だと登録できない' do
        food_form.foods.first.name = ''
        expect(food_form.save).to eq false
      end

      it 'foodsのうち一つのpriceが空だと登録できない' do
        food_form.foods.first.price = nil
        expect(food_form.save).to eq false
      end
    end
  end

  describe 'FoodForm編集' do
    context '空送信によるfoodの削除' do
      it '保存済みのfoodのnameとpriceを空にしてsaveしたら、削除できる' do
        food_form.save
        food = food_form.foods.first
        food_id = food.id
        food.assign_attributes(name: '', price: '')
        expect(food_form.save).to eq true
        expect(Food.find_by(id: food_id)).to be_nil
      end
    end
  end
end
