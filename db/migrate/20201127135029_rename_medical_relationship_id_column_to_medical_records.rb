class RenameMedicalRelationshipIdColumnToMedicalRecords < ActiveRecord::Migration[5.2]
  def change
    rename_column :medical_records, :medical_relationship_id, :hospital_id
  end
end
