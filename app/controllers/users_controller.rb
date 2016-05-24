class UsersController < ApplicationController

  before_action :logged_in_user, except: [:new, :create], if: :none_cooperator_or_admin
  before_action :correct_user, except: [:new, :create], if: :none_cooperator_or_admin

  before_action :logged_in_user, only: [:edit, :update, :destroy], if: :cooperator_exist

  before_action :set_user

  def show
  end

  def new
    @user=User.new
  end

  def create
    @user = User.new(user_params)
    @user.number= Faker::Number.number(10)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      redirect_to root_url, flash: {info: "Please check your email to activate your account."}
    else
      flash[:warning] = "Account saved failed, please try it again"
      render 'new'
    end
  end

  def edit
  end

  def applications
    @applications=@user.applications
  end

  def update
    if @user.update_attributes(user_params)
      # Handle a successful update.
      redirect_to @user, flash: {:success => "Profile updated"}
    else
      flash[:warning] = "Profile updated failed"
      render 'edit'
    end
  end

  def destroy
    user_log_out
    Doorkeeper::Application.filter_by_type(@user.role).each do |app|
      app.users.delete(@user)
    end
    @user.destroy
    redirect_to root_url, flash: {success: "User deleted"}
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :role, :icon, :department)
  end

  # Confirms a logged-in user.
  def logged_in_user
    unless user_logged_in? || admin_logged_in?
      # store_location
      redirect_to root_url, flash: {danger: 'Please log in as User first'}
    end
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    unless current_user?(@user)
      redirect_to user_path(current_user), flash: {:warning => 'You don not have the access to other user except admin'}
    end
  end

  def set_user
    @user = User.find_by_id(params[:id])
  end

  def none_cooperator_or_admin
    current_cooperator.nil?&&current_admin.nil?
  end

  def cooperator_exist
    current_cooperator
  end

end
