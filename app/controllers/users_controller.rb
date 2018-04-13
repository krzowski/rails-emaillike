class UsersController < ApplicationController
  before_action :require_login, only: [:manage, :update, :destroy]
  before_action :prevent_logged_in, only: [:new, :create]
  
  def new
    @user = User.new
  end

  def create 
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Signed up successfully"
      log_in @user
      redirect_to root_path
    else
      flash[:danger] = ''
      flash[:danger] << "Username is taken. "                              if @user.errors.messages[:username]
      flash[:danger] << "Password must be at least 6 characters long. "    if @user.errors.messages[:password]
      flash[:danger] << "Password confirmation didn't match the password." if @user.errors.messages[:password_confirmation]
      render :new
    end
  end

  def manage
    session[:collection] = 'manage'
  end

  def update
    if current_user.username == 'testuser'
      flash.now[:danger] = "You can't change credentials of the test account ;)"    
      render :manage
    elsif current_user.authenticate(params[:user][:current_password])
      if current_user.update_attributes(password_params)
        flash[:success] = "Password was changed" 
        redirect_to manage_path
      else
        flash.now[:danger] = ''
        flash.now[:danger] << "Password must be at least 6 characters long" if current_user.errors.messages[:password]
        flash.now[:danger] << "Password confirmation didn't match the password" if current_user.errors.messages[:password_confirmation]
        render :manage
      end
    else
      flash.now[:danger] = "Current password was incorrect"
      render :manage
    end
  end

  def destroy
    if current_user.username == 'testuser'
      flash[:danger] = "You can't delete the test account ;)"      
    else
      User.find(current_user).destroy
      log_out
      flash[:danger] = "Deleted account"
    end
    redirect_to root_path
  end

  private
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
