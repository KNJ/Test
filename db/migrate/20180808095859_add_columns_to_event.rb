class AddColumnsToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :place_free_entry, :string
  end
end
