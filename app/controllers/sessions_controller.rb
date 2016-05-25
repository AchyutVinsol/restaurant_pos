class SessionsController < ApplicationController

  # include CurrentCart
  # before_action :set_cart
  # skip_before_action :authorize

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && (user.verified? && user.authenticate(params[:password]))
      sign_in(user)
      # set_last_session_activity
      # if user.role == 'admin'
      #   redirect_to admin_reports_url
      # else
      #   redirect_to admin_url
      # end
      redirect_to home_url, alert: "Hi #{ user.first_name }, you have been successfully loggedin!!"
    else
      redirect_to login_url, alert: "Invalid or unverified user/password combination."
    end
  end

  def destroy
    reset_session
    redirect_to home_url, notice: "You have been logged out successfully"
  end
end
