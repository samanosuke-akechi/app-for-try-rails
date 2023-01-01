class TweetTag < ApplicationRecord
  belongs_to :tweet

  validates :name, presence: true
end
