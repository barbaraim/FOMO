class CreateParticipant < ActiveRecord::Migration[7.2]
  def change
    create_table :participants do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.integer :participant_status, default: 0
      t.boolean :notify, default: true
      t.timestamps
    end
  end
end
