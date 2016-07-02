class AddSmallImageToAlbum < ActiveRecord::Migration
    def change
        add_column :albums, :small_image_url, :string, :limit=>1024
    end
end
