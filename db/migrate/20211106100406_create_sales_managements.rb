class CreateSalesManagements < ActiveRecord::Migration[6.0]
  def change
    create_table :sales_managements do |t|
      t.integer :item_id
      t.datetime :sales_date
      t.integer :number_sold

      t.timestamps
    end
  end
end
