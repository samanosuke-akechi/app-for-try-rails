FactoryBot.define do
  factory :food_form do
    consent { true }
    foods { FoodForm::FORM_COUNT.times.map { build(:food) } }

    after(:build) do |food_form|
      area = create(:area)
      food_form.foods.each { |food| food.area = area }
    end
  end
end
