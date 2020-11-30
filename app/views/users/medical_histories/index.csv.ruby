require 'csv'

CSV.generate do |csv|
  column_names = %w(治療開始日 治療終了日 傷病名 治療内容 治療先)
  csv << column_names
  @medical_histories.each do |medical_history|
    column_values = [
      medical_history.started_on,
      medical_history.finished_on,
      medical_history.disease,
      medical_history.treatment,
      medical_history.hospital
    ]
    csv << column_values
  end
end