FactoryBot.define do
  factory :daily_record do
    theme { "題名" }
    introduction { "内容" }
    genre { 0 }
    user
  end
end
