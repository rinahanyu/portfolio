FactoryBot.define do
  factory :health_care do
    body_weight { "00" }
    max_blood_pressure { "00" }
    min_blood_pressure{"00"}
    blood_sugar {"00"}
    date {"2021-01-05"}
    user
  end
end
