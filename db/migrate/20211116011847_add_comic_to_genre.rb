class AddComicToGenre < ActiveRecord::Migration[6.0]
  def change
    add_reference :genres, :comic, null: false, foreign_key: true, after: :name
  end
end
