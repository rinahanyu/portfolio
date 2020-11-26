class AddMinBloodPressureToHealthCares < ActiveRecord::Migration[5.2]
  def change
    add_column :health_cares, :min_blood_pressure, :integer
  end
end
