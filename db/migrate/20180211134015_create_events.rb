class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.datetime :datetime
      t.string :title
      t.string :place
      t.string :description
      t.string :tel
      t.string :email
      t.datetime :general_sale
      t.datetime :presale_start
      t.datetime :presale_end
      t.string :image_id
      t.timestamps

    end
  end
end
