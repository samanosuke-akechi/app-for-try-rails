require 'rails_helper'

RSpec.describe FoodForm, type: :model do
  let(:tag_ids) { FactoryBot.create_list(:tag, 2).pluck(:id) }
  let(:food_form) do
    food_attributes = {}
    3.times do |index|
      food_attributes[index] = FactoryBot.attributes_for(:food)
      food_attributes[index][:tag_ids] = tag_ids
    end
    attributes = { foods: food_attributes, consent: true }
    described_class.new(attributes, area: FactoryBot.create(:area))
  end

  describe 'FoodForm登録' do
    context 'FoodFormが登録できるとき' do
      it 'すべての情報があれば登録できる' do
        expect(food_form.save).to eq true
      end

      it 'foodに紐づくtagsがなくても登録できる' do
        food_form.foods.first.tags = []
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
