class Session::SessionsController < ApplicationController

  def create_admin
    admin = Admin.find_by(email: params[:session][:email].downcase)
    if admin && admin.authenticate(params[:session][:password])
      admin_log_in admin
      params[:session][:remember_me] == '1' ? remember_admin(admin) : forget_admin(admin)
      redirect_to home_index_path,flash: {success: "Welcome admin: #{admin.name} :)"}
    else
      redirect_to root_url(login_role: 'admin'), :flash => { :danger => 'Invalid email/password combination' }
    end
  end

  def destroy_admin
    admin_log_out if admin_logged_in?
    redirect_to root_url
  end

# --------------------------------------------------------------------------

  def create_user
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      if user.activated?
        user_log_in user
        params[:session][:remember_me] == '1' ? remember_user(user) : forget_user(user)
        redirect_to home_index_path,flash: {success: "Welcome user: #{user.name} :)"}
      else
        flash[:warning] = message
        redirect_to root_url, flash: { warning: 'Account not activated. Please check your email for the activation link.'}
      end
    else
      redirect_to root_url, :flash => { :danger => 'Invalid email/password combination' }
    end
  end

  def destroy_user
    user_log_out if user_logged_in?
    redirect_to root_url
  end


# --------------------------------------------------------------------------


  def create_cooperator
    cooperator = Cooperator.find_by(email: params[:session][:email].downcase)
    if cooperator && cooperator.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      cooperator_log_in cooperator
      params[:session][:remember_me] == '1' ? remember_cooperator(cooperator) : forget_cooperator(cooperator)
      redirect_to home_index_path,flash: {success: "Welcome cooperator: #{cooperator.name} :)"}
    else
      # Create an error message.
      redirect_to root_url(login_role: 'cooperator'),:flash => { :danger => 'Invalid email/password combination' }
    end

  end

  def destroy_cooperator
    cooperator_log_out if cooperator_logged_in?
    redirect_to root_url
  end

end
