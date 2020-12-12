class NotificationMailer < ApplicationMailer
  def medical_record_to_user(user, medical_record)
    @user = user
    @medical_record = medical_record
    @url = "https://joyhealth.work/users/sign_in"
    mail(to: @user.email, subject: '診療記録の新規登録があります')
  end
end
