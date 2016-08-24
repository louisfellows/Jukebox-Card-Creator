class AddOptionsToCard < ActiveRecord::Migration
    def change
        add_column :cards, :font, :integer, :default=>1, :null=>false
        add_column :cards, :numbers, :boolean, :null=>false, :default=>true
        add_column :cards, :height, :decimal, :null=>false, :default=>12
        add_column :cards, :width, :decimal, :null=>false, :default=>18
    end
end
