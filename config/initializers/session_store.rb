# Be sure to restart your server when you modify this file.

Photoboom::Application.config.session_store :cookie_store, key: '_photoboom_session',
    :expire_after => 30.days
