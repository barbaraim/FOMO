class AddAdditionalAttributesToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :last_name, :string, null: false
    add_column :users, :age, :integer
    add_column :users, :role, :integer, default: 0
  end
end
