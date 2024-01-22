class AddLineFlagToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :line_flag, :boolean, default: false
  end
end
