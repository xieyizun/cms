class UsersController < ApplicationController

  def create
    user = User.new(params[:user])
    if user.save
      flash[:success] = localize_var(:field_registe_success_hint)
      #疑问
      @user = User.find_by_id(user.id)
      sign_in(@user)
      redirect_to home_path
    else
      flash[:error] = localize_var(:field_registe_failure_hint)
      render 'new'
    end
  end

  def index
  end

  def show
  end

  def edit
  end
end
