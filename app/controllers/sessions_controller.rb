class SessionsController < ApplicationController
  def create
    user = User.login_authenticate(params)
    if user.nil?
      flash[:error] = localize_var(:field_login_failure_hint)
      render 'new'
    else
      flash[:success] = localize_var(:field_login_success_hint)
      set_current_user(user)
      redirect_to home_path
    end
  end
end
