class CardController < ApplicationController
    respond_to :html, :json, :pdf

    load_and_authorize_resource

    def index
        @album_listing = AlbumListing.where(user_id: current_user.id)
        @card = Card.find_by(user_id: current_user.id)

        respond_to do |format|
            format.html
            format.pdf do
                pdf = CardPdf.new(@album_listing, @card)
                send_data pdf.render, filename: 'cards.pdf', type: 'application/pdf'
            end
        end
    end

    def show
    end

    def new
    end

    def create
    end

    def edit
        @card = Card.find_by(user_id: current_user.id)
    end

    def update
        @card = Card.find_by(user_id: current_user.id)
        
        old_numbers = @card.numbers
    
        @card.update_attributes(card_params)
        
        if (old_numbers != @card.numbers)  #show numbers has changed
            #Changing numbered to unnumbered mode. Remove Listings
            AlbumListing.where(:user_id => current_user.id).destroy_all
        end
        
        if @card.numbers == true 
            redirect_to album_listing_numbered_path
        else
            redirect_to album_listing_unnumbered_path
        end
    end

    def delete
    end

    def destroy
    end

    def delete
    end
    
    private     
    def card_params
        params.require(:card).permit(:style, :font, :numbers, :height, :width)
    end
end

