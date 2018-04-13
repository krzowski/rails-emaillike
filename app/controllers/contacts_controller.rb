class ContactsController < ApplicationController
  before_action :require_login
  before_action :nullify_session_ajax, only: [:index]
  
  def index
    session[:collection] = 'contacts'
    @contacts = current_user.contacts
  end

  def create
    contact = current_user.contacts.new(name: params[:name])
    if contact.save
      flash[:success] = "Contact was added"
    else
      flash[:danger] = "Contact already exists"
    end
    if session[:ajax]
      redirect_to email_path(session[:ajax])
    else
      redirect_to :back
    end
  end

  def destroy
    current_user.contacts.find_by(name: params[:name]).destroy
    flash[:danger] = "Contact was removed"
    if session[:ajax]
      redirect_to email_path(session[:ajax])
    else
      redirect_to :back
    end
  end

  private
    def nullify_session_ajax
      session[:ajax] = nil
    end
end