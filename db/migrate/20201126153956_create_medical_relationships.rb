class CreateMedicalRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :medical_relationships do |t|
      t.integer :user_id, null: false
      t.integer :hospital_id, null: false

      t.timestamps
    end
  end
end
