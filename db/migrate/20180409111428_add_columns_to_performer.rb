class AddColumnsToPerformer < ActiveRecord::Migration[5.1]
  def change
    add_reference :performers, :eventt, foreign_key: true
  end
end
