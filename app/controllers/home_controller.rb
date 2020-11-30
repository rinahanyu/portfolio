class HomeController < ApplicationController
  def top
  end

  def new_user_guest
    user = User.find_or_create_by!(
      last_name: "カープ",
      first_name: "坊や",
      last_name_kana: "カープ",
      first_name_kana: "ボウヤ",
      email: "guest_user@example.com",
      postal_code: "0000000",
      address: "広島県",
      telphone_number: "00000000000"
      ) do |user|
      user.password = SecureRandom.urlsafe_base64
    end
    sign_in user
    redirect_to user_path(current_user), notice: "ゲストユーザー（個人利用者用）としてログインしました！"
  end

  def new_hospital_guest
    hospital = Hospital.find_or_create_by!(
      name: "広島病院",
      email: "guest_hospital@example.com",
      postal_code: "0000000",
      address: "広島県",
      telphone_number: "00000000000"
      ) do |hospital|
      hospital.password = SecureRandom.urlsafe_base64
    end
    sign_in hospital
    redirect_to hospital_path(current_hospital), notice: "ゲストユーザー（医療関係者用）としてログインしました！"
  end

  def about_user
  end

  def about_hospital
  end
end
