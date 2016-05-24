require "portal_gate/parser"

class HomeController < ApplicationController
  include HomeHelper

  def index

    if current_admin
      @application=Doorkeeper::Application.all
    else
      if current_cooperator
        @application=current_cooperator.oauth_applications
      else
        if current_user
          @application=current_user.applications
        else
          redirect_to root_url, flash: {danger: 'Please log in first'}
        end
      end

    end
  end

  def gate
    @application=Doorkeeper::Application.all
  end
end
