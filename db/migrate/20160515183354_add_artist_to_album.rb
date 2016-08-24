class AddArtistToAlbum < ActiveRecord::Migration
    def change
        add_column :albums, :artist, :string, :limit=>100, :null=>false, :default=>"Terrorbeard"
    end
end
