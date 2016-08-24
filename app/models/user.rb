class User < ActiveRecord::Base
    has_one :card, :dependent => :destroy
    after_create :create_card

    Roles = { :default => :default, :admin => :admin}

    def is?( requested_role )
        self.role == requested_role.to_s
    end

    class << self
        def from_omniauth(auth_hash)
            user = find_or_create_by(uid: auth_hash['uid'], provider: auth_hash['provider'])
            user.name = auth_hash['info']['name']
            user.location = auth_hash['info']['location']
            user.image_url = auth_hash['info']['image']
            user.save!
            user
        end
    end
    
    private
    def after_create(user)
        Card.create! :user_id => user.id
    end
end
