class CreateNonces < ActiveRecord::Migration[7.0]
  def change
    create_table :nonces do |t|
      t.belongs_to :user, foreign_key: true
      t.string :nonce, null: false
      t.datetime :expires_at, null: false

      t.timestamps
    end
  end
end
