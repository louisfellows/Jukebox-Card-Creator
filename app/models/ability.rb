class Ability
  include CanCan::Ability

    def initialize(user)
        alias_action :calendar => :read
        
        user ||= User.new

        puts "----CANCANCAN----"
        puts user.inspect
        # Define User abilities
        if user.is? :admin
            puts "ISADMIN"
            can :manage, :all
        elsif user.is? :default
            puts "ISDEFAULT"
            can :manage, Album, :user_id => user.id         
            can :manage, Track, :album => {:user_id => user.id}
            can :create, Track
            can :manage, AlbumListing, :user_id => user.id
            can :create, AlbumListing
            can :update, User do |permission_user|
                permission_user.id == user.id
            end            
        else #guest
            puts "GUEST"
            can :read, [Event, Location]
            can :calendar, Event
        end
        puts "-----------------"
        
    end
end
