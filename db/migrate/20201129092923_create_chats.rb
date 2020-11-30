class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :room_id, null: false
      t.integer :user_id
      t.integer :hospital_id
      t.text :message, null: false

      t.timestamps
    end
  end
end
