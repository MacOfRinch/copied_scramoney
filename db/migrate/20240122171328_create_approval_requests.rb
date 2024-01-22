class CreateApprovalRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :approval_requests do |t|
      t.integer :status, default: 0, null: false, limit: 1
      t.text :comment
      t.references :user, null: false, foreign_key: true
      t.references :family, null: false, foreign_key: true

      t.timestamps
    end
  end
end
