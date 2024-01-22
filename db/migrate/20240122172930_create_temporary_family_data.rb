class CreateTemporaryFamilyData < ActiveRecord::Migration[7.0]
  def change
    create_table :temporary_family_data do |t|
      t.string :name
      t.string :nickname
      t.string :avatar
      t.integer :budget
      t.references :approval_request, null: false, foreign_key: true

      t.timestamps
    end
  end
end
