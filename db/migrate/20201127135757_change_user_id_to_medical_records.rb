class ChangeUserIdToMedicalRecords < ActiveRecord::Migration[5.2]
  def change
    change_column :medical_records, :user_id, :integer, null: false
  end
end
