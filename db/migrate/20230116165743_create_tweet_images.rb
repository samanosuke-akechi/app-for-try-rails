class CreateTweetImages < ActiveRecord::Migration[7.0]
  def change
    create_table :tweet_images do |t|
      t.references :tweet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
