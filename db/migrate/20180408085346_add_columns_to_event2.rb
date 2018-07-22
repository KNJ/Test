class AddColumnsToEvent2 < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :date, :date
    add_column :events, :start, :time
    add_column :events, :tel, :string
    add_column :events, :email, :string
  end
end
