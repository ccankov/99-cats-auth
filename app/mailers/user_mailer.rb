class UserMailer < ApplicationMailer
  default from: 'from@example.com'

  def welcome_email(user)
    @user = user
    @url = 'http://localhost:3000/session/new'
    mail(to: user.email, subject: 'Welcome to Cats on Cats on Cats!')
  end
end
