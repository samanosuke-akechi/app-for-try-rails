class Tweet < ApplicationRecord
  has_many :tweet_tags, dependent: :destroy
  has_one :tweet_image, dependent: :destroy

  accepts_nested_attributes_for :tweet_tags, allow_destroy: true
  # reject_ifオプションで指定した条件でtrueになった時にその子モデルを生成しないように設定している
  accepts_nested_attributes_for :tweet_image, allow_destroy: true, reject_if: :storage_file_attached?

  validates :title, :text, presence: true

  delegate :attached?, to: :tweet_image, allow_nil: true

  private

  # 作成・編集のパラメーターにtweet_images.storage_fileがないときにtweet_imageを作成しないためのメソッド
  def storage_file_attached?(attributes)
    # !attached? でも可
    attributes[:storage_file].blank?
  end
end
