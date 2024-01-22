class AddAssociationToFamilyTask < ActiveRecord::Migration[7.0]
  def change
    add_reference :tasks, :family, foreign_key: true
  end
end
