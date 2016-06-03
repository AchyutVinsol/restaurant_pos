class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :signed_in?

  protected

    def ensure_logged_in
      if !current_user
        redirect_to(home_url, notice: 'You are not logged in!')
      end
    end

    def current_user
      @current_user ||= find_user_by_session_or_cookie
    end

    def find_user_by_session_or_cookie
      verified_user = User.verified
      if session[:user_id].present?
        verified_user.find_by(id: session[:user_id])
      elsif cookies[:remember_me_token].present?
        verified_user.find_by(remember_me_token: cookies[:remember_me_token])
      end
    end

    def signed_in?
      !!current_user
    end

    def sign_in(user, remember_me = 'off')
      session[:user_id] = user.id
      if remember_me == 'on'
        user.genrate_remember_me_token!
        cookies.permanent[:remember_me_token] = user.remember_me_token
      end
    end

    def ensure_anonymous
      if signed_in?
        redirect_to(home_url, notice: 'You are already logged in!')
      end
    end

end
