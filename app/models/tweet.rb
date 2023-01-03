class Tweet < ApplicationRecord
  has_many :tweet_tags, dependent: :destroy

  accepts_nested_attributes_for :tweet_tags, allow_destroy: true

  validates :title, presence: true
  validates :text, presence: true
end
