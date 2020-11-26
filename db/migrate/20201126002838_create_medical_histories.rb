class CreateMedicalHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :medical_histories do |t|
      t.integer :user_id, null: false
      t.string :disease, null: false
      t.date :started_on, null: false
      t.date :finished_on
      t.text :treatment, null: false
      t.string :hospital, null: false

      t.timestamps
    end
  end
end
