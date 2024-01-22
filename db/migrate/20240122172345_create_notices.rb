class CreateNotices < ActiveRecord::Migration[7.0]
  def change
    create_table :notices do |t|
      t.string :title
      t.text :content
      t.integer :notice_type, null: false, default: 0
      t.references :family, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :approval_request, foreign_key: true

      t.timestamps
    end
  end
end
