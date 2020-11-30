class ChangeDatatypeStartTimeOfMedicalRecords < ActiveRecord::Migration[5.2]
  def change
    change_column :medical_records, :start_time, :datetime
  end
end
