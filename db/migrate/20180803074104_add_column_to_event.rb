class AddColumnToEvent < ActiveRecord::Migration[5.1]
  def change
    add_reference :events,:user,foreign_key: true
    add_reference :geinins,:user,foreign_key: true
  end
end
