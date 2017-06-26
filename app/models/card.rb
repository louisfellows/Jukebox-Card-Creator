class Card < ActiveRecord::Base
    # Stores card visual settings.
    belongs_to :user
    
    FONTS = { 'Helvetica' => 1, 'Times-Roman' => 2, 'Courier' => 3 } #, 'Symbol' => 4, 'ZapfDingbats'=> 5 }
    NUMBERS = { 'Yes, Display Album Number on the Card' => true,
                'No, Don\'t display Album Number on the Card' => false }
    
    def fontName
        return FONTS.key(font)
    end
end
