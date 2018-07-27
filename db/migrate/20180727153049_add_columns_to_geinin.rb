class AddColumnsToGeinin < ActiveRecord::Migration[5.1]
  def change
    add_column :geinins,:instagram_id,:string
    add_column :geinins,:blog_url,:string
  end
end
