class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :image_id
      t.string :title
      t.string :description
      t.string :tel
      t.string :email
      t.datetime :datetime
      t.string :place
      t.datetime :general_sale
      t.datetime :presale_start
      t.datetime :presale_end
      t.timestamps
      
    end
  end
end
