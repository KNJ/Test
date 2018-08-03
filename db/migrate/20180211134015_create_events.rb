class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.datetime :datetime
      t.string :title
      t.string :place
      t.text :description
      t.string :tel
      t.string :email
      t.datetime :general_sale
      t.datetime :presale_start
      t.datetime :presale_end
      t.string :image_id
      t.references :user, foreign_key: true
      t.timestamps

    end
  end
end
