class CreateTrackListings < ActiveRecord::Migration
    def change
        create_table :track_listings do |t|
            t.column :number, :integer, :null=>false
            t.column :user_id, :integer, :null=>false
            t.column :track_id, :integer, :null=>false
            t.column :created_at, :timestamp, :null => false
        end
    end
end
