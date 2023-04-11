class Food < ApplicationRecord
  belongs_to :area
  has_many :food_tags, dependent: :destroy
  has_many :tags, through: :food_tags

  validates :name, :price, presence: true
end
