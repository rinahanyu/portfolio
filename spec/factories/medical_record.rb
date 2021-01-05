FactoryBot.define do
  factory :medical_record do
    start_time { "2021-01-01" }
    doctor { "医師名" }
    disease { "傷病名" }
    treatment {"診察内容"}
    user
    hospital
  end
end