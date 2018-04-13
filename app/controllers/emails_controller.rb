class EmailsController < ApplicationController
  before_action :require_login
  before_action :nullify_session_ajax, only: [:show]

  def inbox
    session[:collection] = 'received'
    set_emails
    render 'index'
  end

  def sent 
    session[:collection] = 'sent'
    set_emails
    render 'index'
  end

  def show
    @email = current_user.emails.find(params[:id])
    respond_to do |format|
      format.html {
        session[:collection] ||= @email.message_type
        set_emails
        render "show" 
      } 
      format.js   { 
        session[:ajax] = @email.id
        render "email.js.erb", layout: false 
      } 
    end
  end

  def labeled
    session[:collection] = 'label'
    session[:label] = params[:name]
    label = current_user.labels.find_by(name: params[:name])
    set_labeled_emails(label)
    render 'index'
  end

  def change_label
    email = current_user.emails.find(params[:eid])
    label = current_user.labels.find_by(id: params[:lid]) #find_by returns an empty string if there's no match as opposed to throwing an error by find
    email.label = label
    session[:label] = label.name if label
    email.save
    if label
      flash[:success] = "Label was assigned"  
    else
      flash[:success] = "Label was removed"  
    end
    redirect_to email_path(email)
  end

  def new
    session[:collection] = 'new_message'
    @email = current_user.emails.new
  end

  def create
    if params[:save_draft]
      draft = current_user.drafts.new(draft_params)
      if draft.save
        redirect_to draft_path( draft )
      else
        @email = current_user.emails.new(email_params)
        flash.now[:danger] = "Draft must contain an adressee and a title"
        render 'new'
      end
    else
      @email = current_user.emails.new(email_params)
      if @email.valid?
        create_email(email_params) #method delegated to emails_helper
      else
        flash.now[:danger] = "Not all fields are filled"
        render 'new'
      end
    end
  end

  def quick_email
    @email = current_user.emails.new(email_params)
    if @email.valid?
      create_email(email_params) #method delegated to emails_helper
    else
      set_emails
      @email = @emails.find(params[:id])
      flash.now[:danger] = "Response has to convey a message"
      render 'show'
    end
  end  

  def respond
    @email = current_user.emails.find(params[:id])
    @email.title = 'Re: ' + @email.title
    @email.message = ''
    render 'new'
  end

  def forward
    @email = current_user.emails.find(params[:id])
    @email.username = ''
    @email.title = 'Forward: ' + @email.title
    render 'new'
  end

  def correspondence
    session[:collection] = 'correspondence'
    session[:correspondence] = 'both'
    set_correspondence(params[:name])
    render 'index'
  end

  def correspondence_to
    session[:collection] = 'correspondence'
    session[:correspondence] = 'to'
    set_correspondence(params[:name])
    render 'index'
  end

  def correspondence_from
    session[:collection] = 'correspondence'
    session[:correspondence] = 'from'
    set_correspondence(params[:name])
    render 'index'
  end

  def trash
    session[:collection] = 'trash'
    set_trash
  end

  def junk
    @email = current_user.emails.trash.find(params[:id])
    respond_to do |format|
      format.js   { render "junk.js.erb", layout: false } 
    end
  end

  def move_to_trash
    email = current_user.emails.find(params[:id])
    email.trash = true
    email.save
    flash[:danger] = "Moved message to trash"
    
    redirect_to :back
  end

  def move_from_trash
    email = current_user.emails.trash.find(params[:id])
    email.trash = false
    email.save
    session[:collection] = email.message_type
    flash[:success] = "Moved message from trash"
    redirect_to email_path(email)
  end

  def destroy
    current_user.emails.trash.find(params[:id]).destroy
    flash[:danger] = "Message was deleted"
    redirect_to trash_path
  end

  private 
    def email_params
      params.require(:email).permit(:username, :title, :message)
    end

    def draft_params
      params.require(:email).permit(:username, :title, :message)
    end

    def sort_emails 
      session[:sorting] = params[:sort] || session[:sorting] || 'newest'
      @emails = @emails.send(session[:sorting])
    end

    def set_emails
      if session[:collection] == 'received'
        @emails = current_user.emails.received
      elsif session[:collection] == 'sent'
        @emails = current_user.emails.sent
      elsif session[:collection] == 'label'
        @emails = current_user.labels.find_by(name: session[:label]).emails
      elsif session[:collection] == 'correspondence'
        set_correspondence(@email.username) # only for method 'show' use
      else
        @emails = current_user.emails.sent
      end
      sort_emails
    end

    def set_correspondence(name)
      if session[:correspondence] == 'both'
        @emails = current_user.emails.where('lower(username) = lower(?)', name)
      elsif session[:correspondence] == 'to'
        @emails = current_user.emails.sent.where('lower(username) = lower(?)', name)
      elsif session[:correspondence] == 'from'
        @emails = current_user.emails.received.where('lower(username) = lower(?)', name)
      end
      sort_emails
    end

    def set_trash
      @emails = current_user.emails.trash
      sort_emails
    end

    def set_labeled_emails(label)
      @emails = label.emails
      sort_emails
    end

    def nullify_session_ajax
      session[:ajax] = nil
    end
end
