class CardPdf < Prawn::Document
    require "prawn"
    require "prawn/measurement_extensions"
    require "open-uri"

    $WIDTH = 18.cm
    $HEIGHT = 12.cm
    A4_HEIGHT = 29.7.cm
    
    @style = nil 
    @albumListing = nil
   
    def initialize(albumListing, layoutOptions)
        super()
        @albumListing = albumListing
        
        case layoutOptions.style
        when 1
            @style=CardStyleDefault.new(layoutOptions)
        when 2
            @style=CardImageRight.new(layoutOptions)
        end        
                
        $WIDTH = layoutOptions.width.cm
        $HEIGHT = layoutOptions.height.cm
                
        font layoutOptions.fontName
                
        header
        move_down 10
        text_content
    end

    def header
        #This inserts an image in the pdf file and sets the size of the image
        image "#{Rails.root}/app/assets/images/header.png", width: 540, height: 40
    end

    def text_content
        posX = cursor
        @albumListing.each do |aL|
            draw_card 0, posX, aL.album, aL.number, $WIDTH, $HEIGHT
            posX = posX - $HEIGHT - 0.5.cm
            
            if posX - $HEIGHT < 0
                start_new_page
                posX = cursor
            end
        end
    end

    def draw_card(startX, startY, album, albumNo, cardWidth, cardHeight)
        bounding_box([startX, startY], :width => cardWidth, :height => cardHeight) do
            
            draw_image album.image           
            draw_listing album, albumNo
            
            stroke_bounds
        end
    end
    
    private
    
    def draw_image(imageUrl)
        imgDim = @style.getImageDimensions
        image open(imageUrl),   :at => [imgDim['x'],imgDim['y']], 
                                :width => imgDim['width'], 
                                :height => imgDim['height']
    end
    
    
    def draw_listing(album, albumNo)
        listDim = @style.getListingDimensions
                
        x = listDim['x']
        y = listDim['y']
        height = listDim['height']
        width = listDim['width']
    
        bounding_box([x, y], :width => width, :height => height) do
            
            draw_title_box(album, albumNo, 0, height, width)
                                    
            start = cursor - 40
            index = 0
            album.tracks.each do | track |
                puts track.inspect
                text_box "#{track.track_number}.",    
                                                :at => [0, start - (index * 10)],
                                                :width => 0.6.cm,
                                                :height => 10,
                                                :overflow => :truncate,
                                                :size => 10,
                                                :align => :right
                                                
                text_box track.track_name,     :at => [0.7.cm, start - (index * 10)],
                                                :width => width - 1.2.cm,
                                                :height => 10,
                                                :overflow => :truncate,
                                                :size => 10
                index += 1
            end
        end
    end
    
    def draw_title_box(album, albumNo, x, y, width)
        if (@style.display_number?)
            text_box albumNo.to_s,  :at => [x, y],
                                    :width => 30,
                                    :height => 30,
                                    :overflow => :truncate,
                                    :style => :bold,
                                    :size => 28,
                                    :align => :center
            x = x + 30
            width = width - 30
        end
        text_box album.artist,  :at => [x, y],
                                :width => width - 0.1.cm,
                                :height => 15,
                                :overflow => :truncate,
                                :style => :bold,
                                :size => 14
        text_box album.title,   :at => [x, y - 15],
                                :width => width - 0.1.cm,
                                :height => 15,
                                :overflow => :truncate,
                                :style => :bold,
                                :size => 14
    end
end