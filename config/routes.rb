Photoboom::Application.routes.draw do
  get '/dashboard', to: 'dashboard#next_game', as: :dashboard
  get '/next_game', to: 'dashboard#next_game', as: :next_game
  get '/show_teams', to: 'dashboard#show_teams', as: :show_teams
  get '/join_team', to: 'dashboard#join_team', as: :join_team
  get '/leave_team', to: 'dashboard#leave_team', as: :leave_team
  get '/manage_team', to: 'dashboard#manage_team', as: :manage_team

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

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  resources :games
  # TODO: make these sub-routes of games
  resources :photos
  resources :missions
  resources :teams
  resources :registrations
  match '/teams/:id/add_member', to: 'teams#add_member', via: [:get, :post], as: :add_member
  match '/teams/:id/remove_member', to: 'teams#remove_member', via: [:get, :post], as: :remove_member
  match '/teams/:id/rename', to: 'teams#rename', via: [:get, :post], as: :rename_team
  post '/photos/reject', to: 'photos#reject', as: :reject_photo
  get '/games/:game_id/order', to: 'missions#order', as: :missions_order
  post '/games/:game_id/order', to: 'missions#change_order', as: :missions_change_order
  get '/games/:id/recent', to: 'games#recent_photos', as: :recent_photos
  get '/recent', to: 'games#recent_photos'
  get '/check_email', to: 'games#check_email', as: :check_email
  get '/missing', to: 'teams#missing', as: :missing

  # automatically go to their next upcoming game; if they don't have one, will redirect to list of games
  root 'dashboard#next_game'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
