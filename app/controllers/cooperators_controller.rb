class CooperatorsController < ApplicationController
  before_action :logged_in_cooperator, except: [:new, :create], if: :none_admin
  before_action :correct_cooperator, except: [:new, :create], if: :none_admin
  before_action :set_cooperator

  def show
  end

  def new
    @cooperator=Cooperator.new
  end

  def create
    @cooperator= Cooperator.new(cooperator_params)
    if @cooperator.save
      cooperator_log_in(@cooperator)
      redirect_to home_index_path, success: "Successfully sign in"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @cooperator.update_attributes(cooperator_params)
      flash = 'Profile updated'
      redirect_to @cooperator, flash: {success: flash}
    else
      render 'edit'
    end
  end

  def destroy
    @cooperator.destroy
    redirect_to root_url
  end

  def applications
    @applications = @cooperator.oauth_applications
  end

  private

  def cooperator_params
    params.require(:cooperator).permit(:name, :email, :password,
                                       :password_confirmation, :belongings, :icon)
  end

  def logged_in_cooperator
    unless cooperator_logged_in?
      redirect_to root_url(login_role: "cooperator"), flash: {danger: 'Please login as cooperator first'}
    end
  end

  # Confirms the correct user.
  def correct_cooperator
    @cooperator= Cooperator.find(params[:id])
    unless current_cooperator?(@cooperator)
      redirect_to cooperator_path(@cooperator), flash: {:warning => 'You don not have the access to other cooperator except admin'}
    end
  end

  def set_cooperator
    @cooperator = Cooperator.find_by_id(params[:id])
  end

  def none_admin
    current_admin.nil?
  end

end
