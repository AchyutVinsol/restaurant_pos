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

  def order_placed_email(order)
    #FIXME_DONE: you don't need to pass user. just pass order, order.user
    @user = order.user
    #FIXME_DONE: Order.first?
    @order = order
    #FIXME_DONE: need to add order id in subject
    mail to: @user.email, subject: "You have plced an order, your order ID is: #{ @order.id } !"
  end

end
