class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.


  # Controllers produce following session data:
  # session[:user_id]        - to authenticate
  # session[:collection]     - to hold the type of currently active emails action/collection
  #   ['received', 'sent', 'new_message', 'drafts', 'label', 'correspondence', 'trash', 'contacts']
  # session[:ajax]           - to hold the id of an email requested by ajax
  # session[:correspondence] - to hold the type of correspondence ['to', 'from', or 'both']
  # session[:label]          - to hold the value of currently active label
  # session[:sorting]        - to hold the collection's sorting info ['newest', 'oldest']


  protect_from_forgery with: :exception
  include SessionsHelper
  include EmailsHelper
end
