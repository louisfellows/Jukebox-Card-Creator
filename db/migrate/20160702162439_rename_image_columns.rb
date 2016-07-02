class RenameImageColumns < ActiveRecord::Migration
    def change
        rename_column :albums, :image_url, :image
        rename_column :albums, :small_image_url, :small_image
    end
end
