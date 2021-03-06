class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :signed_in?, :require_signed_in, :require_not_signed_in

  def sign_in(user, auth_hash = nil)
    if auth_hash.nil?
      found_user = User.find_by_credentials(user.email, user.password)
    else
      found_user = User.find_by_auth_hash(auth_hash)
    end

    return false unless found_user

    session[:token] = found_user.reset_session_token!
    
    found_user
  end

  def current_user
    User.find_by_session_token(session[:token])
  end

  def signed_in?
    !!current_user
  end

  def sign_out
    current_user.reset_session_token!
    session[:token] = nil
  end
  
  def require_signed_in
    unless signed_in?
      render json: "You must be signed in to do that!", status: :unauthorized
    end
  end
  
  def require_not_signed_in
    if signed_in?
      flash[:notice] = "You must be signed out to do that!"
      redirect_to :back 
    end
  end
      
end
