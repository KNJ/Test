class CreateEventLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :event_links do |t|
      t.references :event, foreign_key: true
      t.string :url

      t.timestamps
    end
  end
end
