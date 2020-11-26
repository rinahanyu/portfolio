class CreateDailyRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :daily_records do |t|
      t.integer :user_id, null:false
      t.string :theme, null:false
      t.text :introduction, null:false
      t.string :daily_image_id
      t.integer :genre, default: 0, null:false, limit: 1

      t.timestamps
    end
  end
end
