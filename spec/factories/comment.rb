FactoryBot.define do
  factory :comment do
    comment { "コメント" }
    user
    daily_record
  end
end