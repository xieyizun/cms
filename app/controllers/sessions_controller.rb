class SessionsController < ApplicationController
  def create
    user = User.login_authenticate(params)
    if user.nil?
      flash[:error] = localize_var(:field_login_failure_hint)
      render 'new'
    else
      flash[:success] = localize_var(:field_login_success_hint)
      sign_in(user)
      redirect_to home_path
    end
  end

  def destroy
    sign_out
    redirect_to home_path, notice: localize_var(:field_logout_successfully)
  end
end
