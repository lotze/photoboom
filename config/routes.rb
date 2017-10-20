require "resque_web"

Photoboom::Application.routes.draw do
  get '/dashboard', to: 'dashboard#next_game', as: :dashboard
  get '/next_game', to: 'dashboard#next_game', as: :next_game
  get '/show_teams', to: 'dashboard#show_teams', as: :show_teams
  get '/join_team', to: 'dashboard#join_team', as: :join_team
  get '/leave_team', to: 'dashboard#leave_team', as: :leave_team
  get '/manage_team', to: 'dashboard#manage_team', as: :manage_team
  match '/teams/:id/add_member', to: 'teams#add_member', via: [:get, :post], as: :add_member
  match '/teams/:id/remove_member', to: 'teams#remove_member', via: [:get, :post], as: :remove_member
  match '/teams/:id/rename', to: 'teams#rename', via: [:get, :post], as: :rename_team
  post '/force_add', to: 'teams#force_add', as: :force_add

  # hardcoded HRSFANS link until I make shortlinks
  get '/hrsfans' => 'games#hrsfans'
  get '/hrsfa' => 'games#hrsfans'

  get '/play', to: 'dashboard#play', as: :play
  get '/review', to: 'dashboard#review', as: :review
  get '/leaderboard', to: 'dashboard#leaderboard', as: :leaderboard
  get '/slideshow', to: 'dashboard#slideshow', as: :slideshow

  # session routes
  get '/login', :to => 'sessions#new', :as => :login
  get '/logout', :to => 'sessions#destroy', :as => :logout
  get '/signin', :to => 'sessions#new', :as => :signin
  get '/signout', :to => 'sessions#destroy', :as => :signout
  get '/auth/:provider/callback', :to => 'sessions#create'
  post '/auth/:provider/callback', :to => 'sessions#create'
  get '/auth/failure', :to => 'sessions#failure'
  get "sessions/create"
  get "sessions/failure"

  # api routes
  get "api/games"
  get "api/photos"
  get "api/signup"
  get "api/join"
  get "api/submit"
  get "api/delete"

  resources :games
  resources :photos
  resources :missions
  resources :registrations
  resources :teams

  # game and photo management
  get '/games/:game_id/order', to: 'missions#order', as: :missions_order
  post '/games/:game_id/order', to: 'missions#change_order', as: :missions_change_order
  match '/games/:game_id/import', to: 'missions#import', via: [:get, :post], as: :missions_import
  get '/games/:id/recent', to: 'games#recent_photos', as: :recent_photos
  get '/games/:id/admin_review', to: 'games#admin_review', as: :admin_review
  get '/games/:id/rejected', to: 'games#rejected', as: :rejected
  get '/games/:id/rules.pdf', to: 'games#rules_pdf', as: :rules_pdf
  get '/games/:id/rules', to: 'games#rules', as: :rules
  post '/photos/reject', to: 'photos#reject', as: :reject_photo
  post '/photos/accept', to: 'photos#accept', as: :accept_photo
  get '/recent', to: 'games#recent_photos'
  get '/missing', to: 'teams#missing', as: :missing

  get '/check_email', to: 'games#check_email', as: :check_email

  # reqeue web dashboard
  resque_web_constraint = lambda do |request|
    current_user ||= User.find_by_id(request.session[:user_id])
    current_user.present? && current_user.respond_to?(:admin?) && current_user.admin
  end

  constraints resque_web_constraint do
    mount ResqueWeb::Engine, at: "/resque_web"
  end


  # automatically go to their next upcoming game; if they don't have one, will redirect to list of games
  root 'dashboard#next_game'
end
