class SessionsController < ApplicationController

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to home_index_path, flash: {success: "Welcome user: #{user.name} :)"}
      else
        redirect_to root_url, flash: {warning: 'Account not activated. Please check your email for the activation link.'}
      end
    else
      redirect_to root_url, :flash => {:danger => 'Invalid email/password combination'}
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
