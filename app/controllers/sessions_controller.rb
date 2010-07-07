# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      
      if session[:params_for_return_to]
        # debugger
      else
        redirect_back_or_default('/')
      end
      
      flash[:notice] = "Logged in successfully"
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

  def from_facebook
    fb_user = FacebookUser.new.user_from_code(params['code'])
    if self.current_user.nil?
      self.current_user = User.find_or_create_by_fb_user(fb_user)
      flash[:notice] = "Logged in via Facebook"
    else
      self.current_user.update_attribute(:fb_id, fb_user.id) unless self.current_user.fb_id == fb_user.id
      flash[:notice] = "Connected your account to facebook"
    end
    redirect_to '/'
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
