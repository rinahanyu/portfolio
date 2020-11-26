class CreateHealthCares < ActiveRecord::Migration[5.2]
  def change
    create_table :health_cares do |t|
      t.integer :user_id, null: false
      t.integer :body_weight
      t.integer :blood_pressure
      t.integer :blood_sugar

      t.timestamps
    end
  end
end
