class ApplicationController < ActionController::Base

  include SessionsHelper
  include ApplicationHelper
  include AccessHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :doorkeeper_authorize!, only: :me

  #required by paper_trail
  before_filter :set_paper_trail_whodunnit

  #required by Cancancan
  # rescue_from CanCan::AccessDenied do |exception|
  #   redirect_to main_app.root_path, :alert => exception.message
  # end

  # GET /me.json
  def me
    render json: current_resource_owner
  end

  private

  # Find the user that owns the access token
  def current_resource_owner
    if doorkeeper_token
      user=User.find(doorkeeper_token.resource_owner_id)
      access=user.accesses.find_by(app_id: doorkeeper_token.application_id)
      return {user: user.as_json, access: access.as_json}
    end
  end

end
