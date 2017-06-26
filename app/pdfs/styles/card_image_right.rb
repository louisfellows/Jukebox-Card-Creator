class CardImageRight < CardStyleDefault
    # Contains style options for the printing of Cards to PDF.
    
    def getImageDimensions
        listingWidth = $WIDTH - $HEIGHT
        dimensions = {  "x"=> listingWidth, 
                        "y" => $HEIGHT,
                        "height" => $HEIGHT,
                        "width" => $HEIGHT }
    end
    
    def getListingDimensions
        listingWidth = $WIDTH - $HEIGHT
        dimensions = {  "x"=> 5, 
                        "y" => $HEIGHT - 5,
                        "height" => $HEIGHT - 5,
                        "width" => listingWidth }
    end
end