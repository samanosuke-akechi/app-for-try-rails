class Comic < ApplicationRecord
  has_many :genres
  accepts_nested_attributes_for :genres
end
