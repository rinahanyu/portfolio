class RenameBloodPressureColumnToHealthCares < ActiveRecord::Migration[5.2]
  def change
    rename_column :health_cares, :blood_pressure, :max_blood_pressure
  end
end
