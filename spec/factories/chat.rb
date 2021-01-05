FactoryBot.define do
  factory :chat do
    message { "メッセージ" }
    user
    hospital
    room
  end
end