# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  helper :all # include all helpers, all the time
  
  before_filter :set_facebook_session
  helper_method :facebook_session
  
  before_filter :find_list
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '15d5ffb393a7fe6c214490cdb576f924'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password
  
  def authenticate
    login_required || return
    
    ivar = instance_variable_get("@#{controller_name.singularize}")
    if ivar && !current_user_owns?(ivar)
      flash[:error] = "You are not the owner of this #{controller_name.singularize}"
      redirect_to_referrer_or_home
    end
  end
  
  helper_method :current_user_owns?
  def current_user_owns?(model)
    (current_user && model.user_id == current_user.id)
  end
  
  private
  
  def find_list
    @list = List.find(session[:list_id]) if session[:list_id] rescue session[:list_id] = nil
  end
end
