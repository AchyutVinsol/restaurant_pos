class PasswordRequestsController < ApplicationController
  before_action :ensure_anonymous, only: [:create, :new]

  def new
  end

  def create
    user = User.verified.find_by(email: params[:email])
    if user
      debugger
      user.fullfill_forgot_password_token!
      redirect_to home_url, notice: "Hi #{ user.first_name }, you have been sent a password reset mail!"
    else
      redirect_to new_password_request_path, notice: "Invalid or unverified email address."
    end
  end
end
