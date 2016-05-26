class UserNotifier < ApplicationMailer
  layout 'mailer'
  default from: CONSTANTS['default_email']

  def verification_email(user)
    @user = user
    mail to: user.email, subject: 'Welcome to ResPOS, kindly verify you email to continue.'
  end

  def forgot_password_email(user)
    @user = user
    mail to: user.email, subject: 'Password reset mail from ResPOS, kindly reset your password!'
  end
end
