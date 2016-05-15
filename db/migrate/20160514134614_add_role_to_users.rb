class AddRoleToUsers < ActiveRecord::Migration
    def change
        add_column :users, :role, :string, :limit=>10, :null=>false, :default=>:default
    end
end
