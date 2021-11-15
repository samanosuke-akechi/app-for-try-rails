class CreateComics < ActiveRecord::Migration[6.0]
  def change
    create_table :comics do |t|
      t.string :title, null: false
      t.string :author, null: false

      t.timestamps
    end
  end
end
