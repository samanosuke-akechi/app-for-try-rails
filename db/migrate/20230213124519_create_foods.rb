class CreateFoods < ActiveRecord::Migration[7.0]
  def change
    create_table :foods do |t|
      t.references :area, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :price, null: false

      t.timestamps
    end
  end
end
