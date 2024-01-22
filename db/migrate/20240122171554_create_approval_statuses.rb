class CreateApprovalStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :approval_statuses do |t|
      t.integer :status, default: 0, null: false, limit: 1
      t.text :comment
      t.references :approval_request, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
