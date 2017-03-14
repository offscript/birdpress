module SessionsHelper
  
 # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def remember(user) #here we call the remember method in the user module with 
#which has the same name for some reason. Maybe to show the difference between
#controller methods and class methods or maybe to confuse me.
    user.remember #create a remember token and assign it in the database
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def current_user
    if (user_id = session[:user_id]) #if session of this user exists set it to the variable of user_id
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  def log_out 
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  def redirect_back_or (default)
    redirect_to (session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
  
  def avatar?
    !current_user.avatar.nil?
  end
  
end
