class AddAssociationTaskUserFamily < ActiveRecord::Migration[7.0]
  def change
    add_reference :task_users, :family, foreign_key: true
  end
end
