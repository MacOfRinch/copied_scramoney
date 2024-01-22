class AddAutoincrementToUser < ActiveRecord::Migration[7.0]
  def up
    change_column :users, :id, :bigint, auto_increment: true
  end

  def down
    change_column :users, :id, :bigint
  end
end
