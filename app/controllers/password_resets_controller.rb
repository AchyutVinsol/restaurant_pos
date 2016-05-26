class PasswordResetsController < ApplicationController

  def new
    @user = User.find_by(forgot_password_token: params[:token])
    if !@user
      redirect_to home_path, notice: 'Invalid forgot password token!'
    end
  end

  def create
    @user = User.find_by(forgot_password_token: params['forgot_password_token'])
    if @user && @user.forgot_password_token_valid?
      @user.reset_password(params[:password], params[:password_confirmation])
      redirect_to home_path, notice: 'Your password has been reset!'
    else
      redirect_to home_path, notice: 'Invalid/Expired forgot password token!'
    end
  end
end
