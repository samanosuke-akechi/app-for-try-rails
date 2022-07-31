class Comic < ApplicationRecord
  has_many :genres, dependent: :destroy

  with_options presence: true do
    validates :title
    validates :author
  end
end
