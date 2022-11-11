class AddSortPriorityToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :sort_priority, :integer
  end
end
