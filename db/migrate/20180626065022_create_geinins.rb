class CreateGeinins < ActiveRecord::Migration[5.1]
  def change
    create_table :geinins do |t|
      t.string :name
      t.string :yomi
      t.string :agency
      t.integer :start_year
      t.string :twitter_id
      t.string :instagram_id
      t.string :youtube_url
      t.string :blog_url
      t.string :official_profile_url
      t.date :end_date
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
