class UserController < ApplicationController
    load_and_authorize_resource

    def index
        @users = User.all
    end 
    
    def create        
        if @user.save
            redirect_to :action => 'index'
        else
            render :action => 'new'
        end
    end
    
    def location_params
        params.require(:user).permit(:name, :location, :role)
    end
   
    def update
        if @user.update_attributes(location_params)
            redirect_to :action => 'show', :id => @user
        else
            @locations = User.all
            render :action => 'edit'
        end
    end
   
    def delete
        @user.destroy
        redirect_to :action => 'index'
    end
end
