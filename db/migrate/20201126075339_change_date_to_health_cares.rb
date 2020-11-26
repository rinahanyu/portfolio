class ChangeDateToHealthCares < ActiveRecord::Migration[5.2]
  def change
    change_column :health_cares, :date, :date, null: false
  end
end
