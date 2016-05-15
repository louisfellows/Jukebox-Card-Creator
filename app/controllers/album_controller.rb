class AlbumController < ApplicationController
    require "erb"
    include ERB::Util

    load_and_authorize_resource :except => [:search, :getAlbumFromLastFM]

    def new
        
    end
    
    def create
    
    end
    
    def search
        respond_to do |format|
            format.json do
                term = I18n.transliterate(params[:term])
            
                url = 'http://ws.audioscrobbler.com/2.0/?method=album.search&album=' + term.to_s + '&api_key=' + ENV['LAST_FM_API_KEY'].to_s + '&limit=20&format=json'   
                        
                response = getJSONResponse(url)
                
                jsonOut = []
                position = 0
                response['results']['albummatches']['album'].each do |a|
                    jsonOut[position] = { "label" => a['artist'] + ' - ' + a['name'],
                                   "value" => a['name'] } 
                    position += 1
                end
                render :json => jsonOut.to_json
            end        
        end
    end
    
    def addAlbum
        respond_to do |format|
            format.json do
                artist = I18n.transliterate(params[:artist])
                album = I18n.transliterate(params[:album])
            
                url = 'http://ws.audioscrobbler.com/2.0/?method=album.getInfo&album=' + album.to_s + '&artist=' + artist.to_s + '&api_key=' + ENV['LAST_FM_API_KEY'].to_s + '&format=json'
                
                response = getJSONResponse(url)
                
                imgUrl = ""
                imgSize = 0
                response['album']['image'].each do |i|
                    case i['size']
                        when "small"
                            currentSize=2
                        when "medium"
                            currentSize=3
                        when "large"
                            currentSize=4
                        when "extralarge"
                            currentSize=5
                        when "mega"
                            currentSize=6
                        else
                            currentSize=1
                    end
                    if currentSize > imgSize
                        imgUrl = i['#text']
                        imgSize = currentSize
                    end
                end
                
                puts response['album']['tracks']['track']
                
                tracks = []
                position = 0
                response['album']['tracks']['track'].each do |t|
                    rank = t["rank"]
                    if (rank == nil) 
                        rank = t["@attr"]["rank"]
                        if (rank == nil) 
                            rank = position
                        end
                    end
                    tracks[position] = {"track" => t['rank'], "title" => t["name"]}
                    position += 1
                end
                
                jsonOut = Hash.new
                jsonOut = { "album"     => response['album']['name'],
                            "artist"    => response['album']['artist'],
                            "image"     => imgUrl,
                            "tracks"    => tracks}

                createAlbum(response['album']['name'], 
                            response['album']['artist'], 
                            imgUrl, 
                            tracks)
                
                render :json => jsonOut.to_json
            end        
        end
    end
    
    private 
    
    def getJSONResponse(url)
        uri = URI(url)
        urlresponse = Net::HTTP.get(uri)
        response = JSON.parse(urlresponse)
    end
    
    def createAlbum(title, artist, imageUrl, tracks)
        album = Album.create(:user_id => current_user.id, :title=>title, :artist=>artist, :image_url => imageUrl)
        album.save()
        tracks.each() do |t|
            if t["track"] == nil 
                t["track"] = 0 
            end
            track = Track.create(:track_name => t["title"], :track_number => t["track"], :album => album)
            track.save()
        end
    end
end
