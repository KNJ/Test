class ChangeColumnsGeininMemberTags < ActiveRecord::Migration[5.1]
  def change
    add_reference :geinin_member_tags, :geinin_member, foreign_key: true

    remove_column :geinin_member_tags, :geinin_member_id_id
  end
end
