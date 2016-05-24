module SessionsHelper

  def user_log_in(user)
    session[:user_id] = user.id
  end

  def user_logged_in?
    !current_user.nil?
  end

  # 点击log_out,安全退出.只关闭浏览器时会保存cookie,
  # 安全退出后就没有了,log_out包括了忘记用户
  def user_log_out
    forget_user(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])
      if user && user.user_authenticated?(:remember, cookies[:remember_token])
        user_log_in user
        @current_user = user
      end
    end
  end

  def remember_user(user)
    user.user_remember
    # Because it places the id as plain text, this method exposes the form of the application’s cookies
    # and makes it easier for an attacker to compromise user accounts. To avoid this problem,
    # we’ll use a signed cookie, which securely encrypts the cookie before placing it on the browser:
    cookies.signed[:user_id] = {value: user.id, expires: 1.years.from_now.utc}
    cookies[:remember_token] = {value: user.remember_token, expires: 1.years.from_now.utc}
  end

  def forget_user(user)
    user.user_forget
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

  # --------------------------------------------------------

  def admin_log_in(admin)
    session[:admin_id] = admin.id
  end

  def admin_logged_in?
    !current_admin.nil?
  end

  # 点击log_out,安全退出.只关闭浏览器时会保存cookie,安全退出后就没有了
  def admin_log_out
    forget_admin(current_admin)
    session.delete(:admin_id)
    @current_admin = nil
  end

  # Returns the user corresponding to the remember token cookie.
  def current_admin
    if session[:admin_id]
      @current_admin||= Admin.find_by(id: session[:admin_id])
    elsif cookies.signed[:admin_id]
      admin = Admin.find_by(id: cookies.signed[:admin_id])
      if admin && admin.admin_authenticated?(:remember, cookies[:remember_token])
        admin_log_in admin
        @current_admin = admin
      end
    end
  end

  def remember_admin(admin)
    admin.admin_remember
    # Because it places the id as plain text, this method exposes the form of the application’s cookies
    # and makes it easier for an attacker to compromise user accounts. To avoid this problem,
    # we’ll use a signed cookie, which securely encrypts the cookie before placing it on the browser:
    cookies.signed[:admin_id] = {value: admin.id, expires: 1.years.from_now.utc}
    cookies[:remember_token] = {value: admin.remember_token, expires: 1.years.from_now.utc}
  end

  def forget_admin(admin)
    admin.admin_forget
    cookies.delete(:admin_id)
    cookies.delete(:remember_token)
  end

  def current_admin?(admin)
    admin == current_admin
  end

  # ---------------------------------------------------------------

  def cooperator_log_in(cooperator)
    session[:cooperator_id] = cooperator.id
  end

  def cooperator_logged_in?
    !current_cooperator.nil?
  end

  # 点击log_out,安全退出.只关闭浏览器时会保存cookie,安全退出后就没有了
  def cooperator_log_out
    forget_cooperator(current_cooperator)
    session.delete(:cooperator_id)
    @current_cooperator = nil
  end

  # Returns the user corresponding to the remember token cookie.
  def current_cooperator
    if session[:cooperator_id]
      @current_cooperator ||= Cooperator.find_by(id: session[:cooperator_id])
    elsif cookies.signed[:cooperator_id]
      cooperator = Cooperator.find_by(id: cookies.signed[:cooperator_id])
      if cooperator && cooperator.cooperator_authenticated?(:remember, cookies[:remember_token])
        cooperator_log_in cooperator
        @current_cooperator = cooperator
      end
    end
  end

  def remember_cooperator(cooperator)
    cooperator.cooperator_remember
    # Because it places the id as plain text, this method exposes the form of the application’s cookies
    # and makes it easier for an attacker to compromise user accounts. To avoid this problem,
    # we’ll use a signed cookie, which securely encrypts the cookie before placing it on the browser:
    cookies.signed[:cooperator_id] = {value: cooperator.id, expires: 1.years.from_now.utc}
    cookies[:remember_token] = {value: cooperator.remember_token, expires: 1.years.from_now.utc}
  end

  def forget_cooperator(cooperator)
    cooperator.cooperator_forget
    cookies.delete(:cooperator_id)
    cookies.delete(:remember_token)
  end

  def current_cooperator?(cooperator)
    cooperator == current_cooperator
  end

end
