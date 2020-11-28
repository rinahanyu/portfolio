class AddUserIdToMedicalRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :medical_records, :user_id, :integer
  end
end
