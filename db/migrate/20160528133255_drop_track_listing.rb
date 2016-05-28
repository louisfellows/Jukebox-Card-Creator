class DropTrackListing < ActiveRecord::Migration
    def change
        drop_table :track_listings
    end
end
