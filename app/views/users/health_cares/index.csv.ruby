require 'csv'

CSV.generate do |csv|
  column_names = %w(日付 体重 最高血圧 最低血圧 血糖値)
  csv << column_names
  @health_cares.each do |health_care|
    column_values = [
      health_care.date,
      health_care.body_weight,
      health_care.max_blood_pressure,
      health_care.min_blood_pressure,
      health_care.blood_sugar
    ]
    csv << column_values
  end
end