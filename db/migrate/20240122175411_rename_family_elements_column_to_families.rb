class RenameFamilyElementsColumnToFamilies < ActiveRecord::Migration[7.0]
  def change
    rename_column :families, :name, :family_name
    rename_column :families, :nickname, :family_nickname
    rename_column :families, :avatar, :family_avatar
  end
end
