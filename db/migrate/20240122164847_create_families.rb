class CreateFamilies < ActiveRecord::Migration[7.0]
  def change
    create_table :families do |t|
      t.string :name, null: false
      t.string :nickname
      t.string :avatar
      t.integer :budget, null: false
      t.integer :budget_of_last_month

      t.timestamps
    end
  end
end
