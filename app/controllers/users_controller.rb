class UsersController < ApplicationController
  before_action :ensure_anonymous, only: [:create]

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to home_path, notice: "Hi #{ @user.first_name }, your account was successfully created, a verifiction email has been sent to #{ @user.email }" 
    else
       render :new 
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
    head :no_content
  end

  def verification
    @user = User.find_by(verification_token: params[:token])
    if @user.nil?
      flash[:notice] = "Invalid authentication token!!"
    elsif @user.verification_token_valid?
      sign_in(@user)
      @user.verify_email!
      flash[:notice] = "Dear #{ @user.first_name }, your email id #{ @user.email } has been verified!"
    else
      flash[:notice] = "Dear #{ @user.first_name }, the verfication failed for id #{ @user.email } since the verfication token expired!"
    end
    redirect_to(home_url)
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
end
