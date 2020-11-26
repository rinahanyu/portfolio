class HealthCare < ApplicationRecord
  belongs_to :user

  validates :body_weight_or_max_blood_pressure_or_min_blood_pressure_or_blood_sugar, presence: true
  validates :body_weight, :max_blood_pressure, :min_blood_pressure, :blood_sugar, numericality: {only_integer: true}, allow_blank: true

# 体重・最高血圧・最低血圧・血糖値のいずれかが入力されているか
  def body_weight_or_max_blood_pressure_or_min_blood_pressure_or_blood_sugar
    body_weight.presence or max_blood_pressure.presence or min_blood_pressure.presence or blood_sugar.presence
  end
end
