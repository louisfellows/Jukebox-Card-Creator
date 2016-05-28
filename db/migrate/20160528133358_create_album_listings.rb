class CreateAlbumListings < ActiveRecord::Migration
    def change
        create_table :album_listings do |t|
            t.column :user_id, :integer, :null=>false
            t.column :album_id, :integer, :null=>false
            t.column :number, :integer, :null=>false
            t.column :created_at, :timestamp, :null => false
        end
    end
end
