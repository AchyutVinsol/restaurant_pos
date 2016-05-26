class PasswordResetsController < ApplicationController
  before_action :ensure_valid_user, only: [:new, :create]

  def new
  end

  def create
    if @user.forgot_password_token_valid?
      @user.reset_password!(params[:password], params[:password_confirmation])
      redirect_to home_path, notice: 'Your password has been reset!'
    else
      redirect_to home_path, notice: 'Invalid/Expired forgot password token!'
    end
  end

  private

    def ensure_valid_user
      @user = User.verified.find_by(forgot_password_token: params[:forgot_password_token])
      if !@user
        redirect_to home_path, notice: 'Invalid forgot password token!'
      end
    end

end
