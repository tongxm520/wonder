module AuthenticationSystem

  SKIP_LOCATIONS=['/login','/logout','/register','/users/forgot']
  SKIP_ACTIONS={"welcome"=>["login"]}

  protected
  def self.included(base)
		base.send :helper_method, :current_user, :logged_in?, :authorized? if base.respond_to? :helper_method
	end

=begin    
  def current_user
    @current_user ||= (login_from_session || login_from_basic_auth || login_from_cookie) unless @current_user == false
  end
=end

  def current_user
    @current_user ? @current_user : login_from_session
  end
 
  def logged_in?
    !!current_user
  end
  
  def authorized?(action = action_name, resource = nil)
    logged_in?
  end
  
  # Store the given user id in the session.
  def current_user=(new_user)
    session[:user_id] = new_user ? new_user.id : nil
    @current_user = new_user ? new_user : nil
  end
  
  # Called from #current_user.  First attempt to login by the user id stored in the session.
  def login_from_session
    User.find_by_id(session[:user_id]) 
  end
  
  # Store the URI of the current request in the session.
  # We can return to this location by calling #redirect_back_or_default.
  def store_location
    session[:return_to] = request.request_uri if request.request_method==:get and not request.xhr? and not skipped?(request)
  end
  
  # Redirect to the URI stored by the most recent store_location call or
  # to the passed default.  Set an appropriately modified
  #   after_filter :store_location, :only => [:index, :new, :show, :edit]
  # for any controller you want to be bounce-backable.
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  private
  def skipped?(request)
    if SKIP_LOCATIONS.index(request.request_uri)
      true
    else
      key=request.params[:controller]
      if SKIP_ACTIONS.has_key?(key) and SKIP_ACTIONS[key].index(request.params[:action])
        true
      else
        false
      end      
    end
  end    
    
end
