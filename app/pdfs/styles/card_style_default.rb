class CardStyleDefault < Object
    # Contains style options for the printing of Cards to PDF.

    @layoutOptions = nil
    $WIDTH = 18.cm
    $HEIGHT = 12.cm

    def initialize(layoutOptions)
        @layoutOptions = layoutOptions
        $WIDTH = layoutOptions.width.cm
        $HEIGHT = layoutOptions.height.cm
    end
    
    def getImageDimensions
        dimensions = {  "x"=> 0, 
                        "y" => $HEIGHT,
                        "height" => $HEIGHT,
                        "width" => $HEIGHT }
    end
    
    def getListingDimensions
        listingWidth = $WIDTH - $HEIGHT
        dimensions = {  "x"=> $HEIGHT + 0.1.cm, 
                        "y" => $HEIGHT - 5,
                        "height" => $HEIGHT - 5,
                        "width" => listingWidth }
    end
    
    def display_number?
        return @layoutOptions.numbers
    end
end