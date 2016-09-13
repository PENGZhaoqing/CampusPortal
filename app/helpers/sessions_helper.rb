module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def user_role?(role)
    logged_in? && current_user.role==role
  end

  def admin_logged_in?
    logged_in? && current_user.admin
  end

  def developer_logged_in?
    logged_in? && current_user.developer
  end

  def logged_in?
    !current_user.nil?
  end

  # 点击log_out,安全退出.只关闭浏览器时会保存cookie,
  # 安全退出后就没有了,log_out包括了忘记用户
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def remember(user)
    user.remember
    # Because it places the id as plain text, this method exposes the form of the application’s cookies
    # and makes it easier for an attacker to compromise user accounts. To avoid this problem,
    # we’ll use a signed cookie, which securely encrypts the cookie before placing it on the browser:
    cookies.signed[:user_id] = {value: user.id, expires: 1.years.from_now.utc}
    cookies[:remember_token] = {value: user.remember_token, expires: 1.years.from_now.utc}
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end


end
