class Oauth::ApplicationsController < Doorkeeper::ApplicationsController
  include SessionsHelper
  layout 'application'

  before_filter :authenticate_cooperator!, if: :none_admin
  before_filter :set_application

  def new
    @application=Doorkeeper::Application.new
  end

  def edit
  end

  def show
  end

  def add_users
    @users=[]
    User.all.each do |user|
      if @application.users.find_by_id(user.id).nil?
        @users<<user
      end
    end
  end

  def list_users
  end

  # only needed if each application must have some owner
  def create
    # @application = Doorkeeper::Application.new(application_params)
    @application =current_cooperator.oauth_applications.new(application_params)
    if @application.save

      User.filter_by_type(@application.user_oriented).each do |user|
        @application.users<<user
        if user.activated?
          user.resource.accesses.create!(node: [1], path: [1], app_id: @application.id)
        end
      end

      flash[:notice] = I18n.t(:notice, :scope => [:doorkeeper, :flash, :applications, :create])
      redirect_to oauth_application_path(@application)
    else
      render :new
    end
  end

  def update
    if @application.update_attributes(application_params)
      flash[:notice] = I18n.t(:notice, scope: [:doorkeeper, :flash, :applications, :update])
      redirect_to oauth_application_url(@application)
    else
      render :edit
    end
  end

  def destroy
    User.filter_by_type(@application.user_oriented) do |user|
      user.applications.delete(@application)
      user.resources.accesses.find_by(app_id: @application.id).destroy!
    end
    flash[:notice] = I18n.t(:notice, scope: [:doorkeeper, :flash, :applications, :destroy]) if @application.destroy
    redirect_to applications_cooperator_path(@cooperator) ,success: 'Successful destroy the app'
  end

  private

  def authenticate_cooperator!
    unless cooperator_logged_in?
      # store_location
      redirect_to root_url, flash: {alert: "Please log in as cooperator"}
    end
    @cooperator=current_cooperator
  end

  def set_application
    @application =Doorkeeper::Application.find_by_id(params[:id])
  end

  def application_params
    if params.respond_to?(:permit)
      params.require(:doorkeeper_application).permit(:name, :homepage, :description, :user_oriented, :redirect_uri, :scopes, :picture)
    else
      params[:doorkeeper_application].slice(:name, :homepage, :redirect_uri, :scopes) rescue nil
    end
  end

  def none_admin
    current_admin.nil?
  end

end