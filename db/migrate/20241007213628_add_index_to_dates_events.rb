class AddIndexToDatesEvents < ActiveRecord::Migration[7.2]
  def change
    add_index :events, :start_date
    add_index :events, :end_date
  end
end
