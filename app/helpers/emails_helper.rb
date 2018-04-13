module EmailsHelper
  def active?(collection)
    'active' if session[:collection] == collection
  end

  def represent_date_of_email(datetime)
    if datetime.to_date == Date.today
      datetime.strftime("%H:%M")
    elsif datetime.to_date == Date.yesterday
      'Yesterday'
    else
      datetime.strftime("%d.%m")
    end 
  end

  def link_to_if_inactive_sort(sort)
    unless session[:sorting] == sort
      link_to "<div class='sorting-option'>Date - #{sort}</div>".html_safe, sort: "#{sort}"
    end
  end

  def create_email(params)
    @email = current_user.emails.new(params)
    interlocutor = User.find_by(username: params[:username])      
    @email.message_type = 'sent'
    @email.interlocutor_id = interlocutor.id if interlocutor
    
    @email.save
    # simulate receiving email if interlocutor exists
    create_received_email(@email, params, interlocutor) if interlocutor
    session[:collection] = 'sent'
    
    flash[:success] = "Email was sent"
    redirect_to email_path(@email)
  end

  def create_received_email(email, params, interlocutor)
    email_received = interlocutor.emails.new(params)
    email_received.interlocutor_id = current_user.id
    email_received.username = current_user.username
    email_received.message_type = 'received'
    email_received.save
  end
end