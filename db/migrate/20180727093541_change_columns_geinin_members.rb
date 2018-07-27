class ChangeColumnsGeininMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :geinin_members, :family_name, :string, null: false
    add_column :geinin_members, :first_name, :string, null: false
    add_column :geinin_members, :family_name_yomi,:string
    add_column :geinin_members, :first_name_yomi,:string
    remove_column :geinin_members, :name, :string
    remove_column :geinin_members, :yomi, :string 
  end
end
