module SessionsHelper
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def current_user=(user)
    @user = user
  end

  def current_user
    @user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def sign_in?
    !current_user.nil?
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def inspect_if_sign_in
    unless sign_in?
      redirect_to signin_path, notice: localize_var(:field_signin_first)
    end
  end
end
