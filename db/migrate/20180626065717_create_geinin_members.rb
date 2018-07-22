class CreateGeininMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :geinin_members do |t|
      t.references :geinin, foreign_key: true
      t.string :name
      t.string :yomi
      t.string :twitter_id
      t.string :instagram_id
      t.string :blog_url

      t.timestamps
    end
  end
end
