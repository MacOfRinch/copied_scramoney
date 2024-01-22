class AddStatusToFamily < ActiveRecord::Migration[7.0]
  def change
    add_column :families, :status, :integer, default: 0
  end
end
