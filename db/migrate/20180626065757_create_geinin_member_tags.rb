class CreateGeininMemberTags < ActiveRecord::Migration[5.1]
  def change
    create_table :geinin_member_tags do |t|
      t.references :geinin, foreign_key: true
      t.references :geinin_member, foreign_key: true
      t.string :tag

      t.timestamps
    end
  end
end
