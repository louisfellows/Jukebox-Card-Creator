class AlbumController < ApplicationController
    respond_to :html, :json

    load_and_authorize_resource :except => [:search, :getAlbumFromLastFM]

    def index
    end

    def show
    end

    def new
    end

    def create
    end

    def edit
    end

    def update
        respond_to do |format|
            format.json do
                @album = Album.find(params[:id])
                @album.update_attributes(album_params)
                respond_with @album
            end
        end
    end

    def delete
    end

    def destroy
        @album = Album.find(params[:id])
        @album.destroy
    end

    def delete
        @album = Album.find(params[:album_id])
    end
    
    # Search Last.fm for a list of albums matching the search term, return them as a JSON list.
    def search
        respond_to do |format|
            format.json do
                albums = Album.searchLastFM(params[:term])
                
                jsonOut =[]
                position = 0
                albums.each do |a|
                    jsonOut[position] = { "label" => a.artist + ' - ' + a.title, "value" => a.title } 
                    position += 1
                end
                render :json => jsonOut.to_json
            end        
        end
    end
    
    # Get album data from Last.fm and create a new album. Save the new album to the database.
    def addAlbum
        respond_to do |format|
            format.json do
                album = Album.getAlbumFromLastFM(params[:artist], params[:album])
                album.user_id = current_user.id
                album.save()
                render :json => album.as_json(include: :tracks)
            end        
        end
    end
    
    # Change a tracks position on an album.
    def updateRowOrder
        respond_to do |format|
            format.json do
                puts (:params)
                movedTrack = Track.find(params[:track][:track_id])
                newPosition = params[:track][:row_order_position].to_i
                newPosition += 1 #jQuery is 0 indexed, our albums are 1 indexed
                album = movedTrack.album
                album.updateTrackOrder(movedTrack, newPosition)
                render :json => album.as_json(include: :tracks)
            end        
        end
    end
        
    private     
    def album_params
        params.require(:album).permit(:title, :artist)
    end
end
