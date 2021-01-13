FactoryBot.define do
  factory :hospital do
    name { "赤十字病院" }
    address { "広島県" }
    email { "s@s" }
    telphone_number { 000000000000 }
    postal_code { 00000000 }
    password { "password" }
  end
end