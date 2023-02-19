class Food < ApplicationRecord
  belongs_to :area

  validates :name, :price, presence: true
end
