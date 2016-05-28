class DropTrackListing < ActiveRecord::Migration
    def change
        drop_table :track_listing
    end
end
