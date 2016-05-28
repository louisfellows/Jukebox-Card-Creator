class TrackListingController < ApplicationController
    load_and_authorize_resource :except => [:calendar]

    def index
        @albums = Album.where(:user_id => current_user.id)
    end 
    
    def new
    end
   
    def create        
    end

    def edit
    end
   
    def update        
    end
   
    def delete
    end

end
