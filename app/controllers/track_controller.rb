class TrackController < ApplicationController
    respond_to :html, :json

    load_and_authorize_resource

    def index
    end

    def show
    end

    def new
    end

    def create   
        album = Album.find(params[:album_id])
        
        album.normaliseTrackOrder
        
        track = Track.new({:track_name => params[:track_name], :track_number => album.tracks.length + 1})
        album.tracks << track
        track.save()
        album.save()  
        
        @album = album
        @track = track
    end

    def edit
    end

    def update
        respond_to do |format|
            format.json do
                puts params
                @track = Track.find(params[:id])
                @track.update_attributes(album_params)
                respond_with @track
            end
        end
    end
    
    def delete
        @track = Track.find(params[:track_id])
    end

    def destroy
        @track = Track.find(params[:id])
        @track.destroy
    end
    
    private     
    def album_params
        params.require(:track).permit(:track_name, :track_number)
    end
end
