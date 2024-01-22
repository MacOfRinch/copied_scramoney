class AddCategoryNameToTask < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :category_name, :integer, null: false, default: 0
  end
end
