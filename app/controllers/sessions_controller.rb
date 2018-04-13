class SessionsController < ApplicationController
  before_action :require_login, only: :destroy
  before_action :prevent_logged_in, only: :create

  def create
    user = User.where("lower(username) = ?", params[:session][:username].downcase).first
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_path
    else
      flash.now[:danger] = "Invalid username/password combination"
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end  
end
