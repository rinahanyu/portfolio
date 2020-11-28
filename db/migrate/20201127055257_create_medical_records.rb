class CreateMedicalRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :medical_records do |t|
      t.integer :medical_relationship_id, null: false
      t.date :examined_on, null: false
      t.string :doctor, null: false
      t.string :disease, null: false
      t.text :treatment, null: false

      t.timestamps
    end
  end
end
