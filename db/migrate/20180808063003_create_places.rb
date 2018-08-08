class CreatePlaces < ActiveRecord::Migration[5.1]
  def change
    create_table :places do |t|
      t.string :name
      t.string :station
      t.string :prefecture
      t.string :area
      t.text :address
      t.integer :tel
      t.text :access
      t.integer :capacity
      t.string :map_url
      t.string :twitter_id
      t.string :blog_url
      t.string :official_hp_url
      t.text :remarks

      t.timestamps
    end
  end
end
