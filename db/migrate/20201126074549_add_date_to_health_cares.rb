class AddDateToHealthCares < ActiveRecord::Migration[5.2]
  def change
    add_column :health_cares, :date, :date
  end
end
