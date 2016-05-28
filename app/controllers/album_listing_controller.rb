class AlbumListingController < ApplicationController
    load_and_authorize_resource 
    skip_load_resource :only => [:destroy]

    def index
        @albums = Album.where("user_id = ? AND id NOT IN (SELECT DISTINCT album_id FROM album_listings)", current_user.id);
        @listings = AlbumListing.where(:user_id => current_user.id).order('number ASC')
    end 
    
    def new
    end
   
    def create        
        album_listing = AlbumListing.create(album_listing_params)
        respond_to do |format|
            format.json { head :ok }
        end
    end

    def edit
    end
   
    def update        
    end
   
    def destroy
        albumListing = AlbumListing.where(  :number => params[:number], 
                                            :album_id => params[:album_id],
                                            :user_id => current_user.id)
                                   .destroy_all
        respond_to do |format|
            format.json { head :ok }
        end
    end

    private
    def album_listing_params
        params.require(:album_listing).permit(:number, :album_id).merge(user_id: current_user.id)
    end
end
