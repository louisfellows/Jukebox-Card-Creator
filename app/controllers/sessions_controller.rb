class SessionsController < ApplicationController
    def new
        
    end
    
    def create
        begin
            @user = User.from_omniauth(request.env['omniauth.auth'])
            session[:user_id] = @user.id
            flash[:success] = "Welcome, #{@user.name}!"
        rescue => e
            flash[:warning] = "There was an error while trying to authenticate you. '#{e}'"
        end
        redirect_to root_path
    end
    
    def destroy
        if current_user
            session.delete(:user_id)
            flash[:success] = 'See you!'
        end
            redirect_to root_path    
    end
    
    def auth
    
    end
    
    def auth_failure
        flash[:error] = "Authentication Failure"
        redirect_to root_path
    end
end
