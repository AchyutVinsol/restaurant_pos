class SessionsController < ApplicationController
  before_action :ensure_no_session, only: [:new, :create]

  # include CurrentCart
  # before_action :set_cart
  # skip_before_action :authorize

  def new
  end

  def create
    # debugger
    user = User.find_by(email: params[:email])
    if user && (user.verified? && user.authenticate(params[:password]))
      sign_in(user)
      if params[:remember_me] == 'on'
        # debugger
        user.genrate_remember_me_token
        cookies.permanent[:remember_me_token] = user.remember_me_token
      end
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
    #FIXME_AB: put in a diffrent method??
    current_user.remember_me_token = nil
    cookies.delete :remember_me_token

    reset_session
    redirect_to home_url, notice: "You have been logged out successfully"
  end

  private

    def ensure_no_session
      if signed_in?
        redirect_to login_url, alert: "#{ current_user.first_name } is already loggedin!!"
      end
    end

end
