class RenameExaminedOnColumnToMedicalRecords < ActiveRecord::Migration[5.2]
  def change
    rename_column :medical_records, :examined_on, :start_time
  end
end
