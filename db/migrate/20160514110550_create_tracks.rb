class CreateTracks < ActiveRecord::Migration
    def change
        create_table :tracks do |t|
            t.column :album_id, :integer, :null=>false
            t.column :track_name, :string, :limit=>100, :null=>false
            t.column :track_number, :integer, :null=>false
            t.column :created_at, :timestamp, :null => false
        end
    end
end
