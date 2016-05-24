class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.user_authenticated?(:activation, params[:id])
      user.update_attribute(:activated,    true)
      user.update_attribute(:activated_at, Time.zone.now)

      @resource=user.create_resource(name: user.name)
      Doorkeeper::Application.filter_by_type(user.role).each do |app|
        user.applications<<app
        @resource.accesses.create!(node: [1], path: [1], app_id: app.id)
      end

      user_log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
