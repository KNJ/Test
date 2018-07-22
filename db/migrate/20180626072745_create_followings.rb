class CreateFollowings < ActiveRecord::Migration[5.1]
  def change
    create_table :geinin_followings do |t|
      t.references :user, foreign_key: true
      t.references :geinin, foreign_key: true

      t.timestamps
    end
  end
end