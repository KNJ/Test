class CreatePendings < ActiveRecord::Migration[5.1]
  def change
    create_table :pendings do |t|
      t.references :event, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
