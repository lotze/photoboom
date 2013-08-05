Rails.application.config.middleware.use OmniAuth::Builder do
  provider :identity, :fields => [:email], :on_failed_registration => SessionsController.action(:failure)
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET']
end
