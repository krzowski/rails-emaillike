class LabelsController < ApplicationController
  before_action :require_login

  def create
    if current_user.labels.count >= 5  # simulate fake model limit for presentational reasons
      flash[:danger] = "Labels limit reached"
      redirect_to :back
    else
      if params[:name].nil?
        flash[:danger] = "Label must have name"
      elsif current_user.labels.new(name: params[:name].downcase.capitalize).save
        flash[:success] = "Label was created"
      else
        flash[:danger] = "Label can only have up to 10 characters"
      end

      if session[:ajax]
        redirect_to email_path(session[:ajax])
      else
        redirect_to :back
      end
    end
  end

  def destroy
    current_user.labels.find(params[:id]).destroy
    flash[:danger] = "Label was removed"
    redirect_to manage_path
  end
end