module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
    session[:collection] = 'inbox'
    session[:sorting] = 'newest'
  end

  def current_user
    current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.clear
    @current_user = nil
  end

  def require_login
    return render 'users/guest' unless logged_in?
  end

  def prevent_logged_in
    return redirect_to root_path if logged_in?
  end
end
