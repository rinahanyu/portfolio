FactoryBot.define do
  factory :health_care do
    body_weight { 0 }
    max_blood_pressure { 0 }
    min_blood_pressure{ 0 }
    blood_sugar { 0 }
    date {"2021-01-05"}
    user
  end
end
