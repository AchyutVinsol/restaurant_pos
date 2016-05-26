class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :signed_in?

  protected

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def signed_in?
      !!current_user
    end

    def sign_in(user)
      session[:user_id] = user.id
    end

    def ensure_anonymous
      if signed_in?
        redirect_to(home_url, notice: 'You are already logged in!')
      end
    end

    def signed_out?
      !current_user
    end

end
