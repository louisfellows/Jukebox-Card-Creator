class AlbumListingController < ApplicationController
    load_and_authorize_resource 
    skip_load_resource :only => [:destroy]

    def index
        if (Card.find_by(user_id: current_user.id).numbers == true)
            redirect_to album_listing_numbered_path
        else
            redirect_to album_listing_unnumbered_path
        end
    end 
    
    # numbered and unnumbered are separate views as last.fm can give both numbered and unnumbered track listings. The views
    # are separate, but the controller section for both is identical. 
    # TODO: is there a way to combine these and still have separate pages and eliminate the repeated code?
    def numbered
        if (Card.find_by(user_id: current_user.id).numbers == false) 
            redirect_to album_listing_unnumbered_path
        end
        
        @albums = Album.where("user_id = ? AND id NOT IN (SELECT DISTINCT album_id FROM album_listings)", current_user.id);
        @listings = AlbumListing.where(:user_id => current_user.id).order('number ASC')
    end 
    
    def unnumbered
        if (Card.find_by(user_id: current_user.id).numbers == true)
            redirect_to album_listing_numbered_path
        end
        
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
