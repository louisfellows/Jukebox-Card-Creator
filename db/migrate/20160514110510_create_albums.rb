class CreateAlbums < ActiveRecord::Migration
    def change
        create_table :albums do |t|
            t.column :user_id, :integer, :null=>false
            t.column :title, :string, :limit=>100, :null=>false
            t.column :image_url, :string, :limit=>1024
            t.column :created_at, :timestamp, :null => false
        end
    end
end
