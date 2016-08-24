class CreateCards < ActiveRecord::Migration
    def change
        create_table :cards do |t|
            t.column :user_id, :integer, :null => false
            t.column :style, :integer, :null => false, :default => 1
        
            t.timestamps null: false
        end
    end
end