FactoryBot.define do
  factory :user do
    last_name { "太郎" }
    first_name { "広島" }
    last_name_kana { "ヒロシマ" }
    first_name_kana { "タロウ" }
    address { "広島県" }
    email { "h@h" }
    telphone_number { 0o0000000000 }
    postal_code { 0o000000 }
    password { "password" }
  end
end