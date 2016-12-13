class UserNotifier < ApplicationMailer
  layout 'mailer'
  default from: CONSTANTS[:default_email_id]

  def verification_email(user)
    @user = user
    mail to: user.email, subject: 'Welcome to ResPOS, kindly verify you email to continue.'
  end

  def forgot_password_email(user)
    @user = user
    mail to: user.email, subject: 'Password reset mail from ResPOS, kindly reset your password!'
  end

  def order_placed_email(order)
    @user = order.user
    @order = order
    mail to: @user.email, subject: "You have plced an order, your order ID is: #{ @order.id } !"
  end

end
