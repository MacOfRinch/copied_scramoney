class AddAttributesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :nickname, :string
    add_column :users, :avatar, :string
    add_column :users, :pocket_money, :integer
  end
end
