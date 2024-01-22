class AddColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :points, :integer, default: 0
    add_column :users, :points_of_last_month, :integer, default: 0
    add_column :users, :pocket_money_of_last_month, :integer, default: 0
  end
end
