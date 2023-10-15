class TweetImage < ApplicationRecord
  belongs_to :tweet
  has_one_attached :storage_file

  delegate :attached?, to: :storage_file, allow_nil: true

  validate :storage_file_attached?

  private

  def storage_file_attached?
    return true if storage_file.attached?

    errors.add(:storage_file, 'を選択してください')
  end
end
