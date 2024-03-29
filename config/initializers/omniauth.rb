Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'],
  {
    scope: "email, profile",
    skip_jwt: true
  }
end
OmniAuth.config.allowed_request_methods = %i[get post]