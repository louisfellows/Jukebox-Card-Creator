class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
  
    rescue_from CanCan::AccessDenied do |exception|
        flash[:warning] = exception.message
        begin 
            redirect_to :back
        rescue ActionController::RedirectBackError
            redirect_to root_path
        end
    end
  
    private

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    helper_method :current_user
end
