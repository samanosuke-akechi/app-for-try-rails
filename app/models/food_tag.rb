class FoodTag < ApplicationRecord
  belongs_to :food
  belongs_to :tag

  validates :food, uniqueness: { scope: :tag }
end
