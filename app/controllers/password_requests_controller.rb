class PasswordRequestsController < ApplicationController
  def new
  end

  def create
    # debugger
    user = User.find_by(email: params[:email])
    if user && user.verified?
      #genrate forgot_password_token and forgot_password_expiry_at
      # debugger
      user.genrate_forgot_password_token
      #send mail
      UserNotifier.forgot_password_email(user).deliver_now
      redirect_to home_url, notice: "Hi #{ user.first_name }, you have been sent a password reset mail!"
    else
      redirect_to password_requests_create_path, notice: "Invalid or unverified email address."
    end
  end
end
