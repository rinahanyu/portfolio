class HelloMailer < ApplicationMailer
  def hello_to_user
    @url = "https://joyhealth.work/users/sign_in"
    mail(to: User.pluck(:email), subject: '今日も１日楽しく過ごそう！')
  end
end
