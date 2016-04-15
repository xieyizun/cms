module SessionsHelper
  def set_current_user(user)
    @user = user
    cookies[:remember_token] = user.remember_token
  end

  def current_user
    @user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?
    @user = current_user
    @user.nil?
  end
end
