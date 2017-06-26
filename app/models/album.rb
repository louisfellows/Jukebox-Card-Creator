class Album < ActiveRecord::Base
    belongs_to :user
    has_many :tracks, -> { order 'track_number ASC' }
    has_one :album_listing, :dependent => :destroy

    def image
        if (!self[:image].nil?) and 
            (!self[:image].empty?) and
            (checkImageExists(self[:image]))
            return self[:image]
        end
        return "no_image.png"
    end
    
    def small_image
        if (!self[:small_image].nil?) and 
            (!self[:small_image].empty?) and 
            (checkImageExists(self[:small_image]))
            return self[:small_image]
        end
        return "no_image_small.png"
    end
    
    # Search Last.fm for an album and return an array of results.
    def self.searchLastFM(term)
        term = I18n.transliterate(term)
    
        url = 'http://ws.audioscrobbler.com/2.0/?method=album.search&album=' + term.to_s + '&api_key=' + ENV['LAST_FM_API_KEY'].to_s + '&limit=20&format=json'   
                
        response = getJSONResponse(url)
        
        results =[]
        position = 0
        response['results']['albummatches']['album'].each do |a|
            results[position] = Album.new( :artist => a['artist'], :title => a['name']) 
            position += 1
        end
        results
    end
    
    # Search Last.fm for a specific album, create a new Album object from the response and return it.
    def self.getAlbumFromLastFM(artist, album)
        artist = I18n.transliterate(artist)
        album = I18n.transliterate(album)
    
        url = 'http://ws.audioscrobbler.com/2.0/?method=album.getInfo&album=' + album.to_s + '&artist=' + artist.to_s + '&api_key=' + ENV['LAST_FM_API_KEY'].to_s + '&format=json'
        
        response = getJSONResponse(url)
        
        imgUrl = ""
        imgSize = 0
        smImgUrl = ""
        smImgSize = 0
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
            if currentSize < smImgSize or smImgSize == 0
                smImgUrl = i['#text']
                smImgSize = currentSize
            end
        end
                
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
            tracks[position] = Track.new(:track_number => rank, :track_name => t["name"])
            position += 1
        end         
        
        Album.new(  :title           =>  response['album']['name'],
                    :artist          =>  response['album']['artist'],
                    :image           =>  imgUrl,
                    :small_image     =>  smImgUrl,
                    :tracks          =>  tracks )
    end
    
    # Move a tracks position in the track listing of an album, update other tracks to maintain the track listing.
    def updateTrackOrder(movedTrack, newPosition)
        tracklist = tracks.order('tracks.track_number ASC').all
        position = 1
        tracklist.each do |t|
            if t.id != movedTrack.id 
                if newPosition == position
                    movedTrack.track_number = position
                    movedTrack.save()
                    position += 1
                end 
                t.track_number = position
                position += 1
                t.save()
            end
        end
    end
        
    # Update all track numbers to ensure listing from 1->x and fix errored numbering from Last.fm.
    def normaliseTrackOrder
        tracklist = tracks.order('tracks.track_number ASC').all
        position = 1
        tracklist.each do |t|
            t.track_number = position
            position += 1
            t.save()
        end
    end

    # Returns a array of numbered tracks for use in a table.
    def getTracksAsTable
        table = []
        tracks.each do |track|
            table.push(["#{track.track_number}.", track.track_name])
        end
        return table
    end
    
    private 
    
    def self.getJSONResponse(url)
        urlresponse = HTTParty.get(url)
        response = JSON.parse(urlresponse.body)
    end
        
    def checkImageExists(url)
        response = HTTParty.get(url)
        if response.code == 200
            return true
        end
        return false
    end 

end
