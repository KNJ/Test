class ChangeColumnGeininMember < ActiveRecord::Migration[5.1]
  def change
    change_column :geinin_members, :first_name, :string, null: true
  end
end
