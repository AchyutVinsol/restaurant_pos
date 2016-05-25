class PagesController < ApplicationController
  before_action :permit_whitelist_page

  def show
    render template: "pages/#{params[:page]}"
  end

  private

    def permit_whitelist_page
      if !['info', 'about', 'home'].include?(params[:page])
        params[:page] = :home
        flash[:notice] = 'The page you tried to access does not exist!'
      end
    end

end
