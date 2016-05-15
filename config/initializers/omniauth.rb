Rails.application.config.middleware.use OmniAuth::Builder do
    OmniAuth.config.on_failure = Proc.new do |env| 
        SessionsController.action(:auth_failure).call(env)
    end

    provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], scope: 'public_profile', info_field: 'id,name,link'
    provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_SECRET"], scope: 'profile', image_aspect_ratio: 'square', image_size: 48, access_type: 'online', name: 'google'

end