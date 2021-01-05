FactoryBot.define do
  factory :medical_history do
    disease { "傷病名" }
    started_on { "2021-01-01" }
    finished_on { "2021-01-01" }
    treatment {"治療内容"}
    hospital {"治療先"}
    user
  end
end