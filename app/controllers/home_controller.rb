class HomeController < ApplicationController
  include HomeHelper

  def index
    if admin_logged_in?
      @application=Doorkeeper::Application.all
    elsif developer_logged_in?
      @application=current_user.oauth_applications
    elsif logged_in?
      @application=current_user.applications
    else
      redirect_to root_url, flash: {danger: 'Please log in first'}
    end
  end

  def gate
    @application=Doorkeeper::Application.all
  end

end
