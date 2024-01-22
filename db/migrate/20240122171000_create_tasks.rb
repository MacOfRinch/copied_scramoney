class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.integer :points, null: false
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
