class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true, null: false
      t.string :review
      t.integer :rating

      t.timestamps
    end
  end
end
