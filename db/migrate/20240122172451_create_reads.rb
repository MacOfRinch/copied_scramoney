class CreateReads < ActiveRecord::Migration[7.0]
  def change
    create_table :reads do |t|
      t.boolean :checked, default: false
      t.references :notice, null:false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
