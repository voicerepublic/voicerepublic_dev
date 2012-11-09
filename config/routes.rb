Kluuu2::Application.routes.draw do

  resources :video_rooms
  resources :video_sessions
  
  #route to video-client_config
  match 'bbb/:meeting_id/user/:user_id/config' => "video_sessions#video_session_config"
  #routes to payment
  match 'user_joined' => 'payment#user_joined'
  match 'user_left' => 'payment#user_left'
  match 'meeting_begin' => 'payment#meeting_begin'
  match 'meeting_end' => 'payment#meeting_end'
  match 'payment_started' => 'payment#payment_started'
  match 'payment_stopped' => 'payment#payment_stopped'
  
  get 'users/online_users' => 'users#online_users'
  
  
  scope "(/:locale)", :locale => /de|en/ do
    get "dashboard", :controller => "dashboard", :action => :index #, :as => 'user_root'
    get "dashboard/contacts"
    get "dashboard/bookmarks"
    get "dashboard/news"
    get "dashboard/matches"
    get "dashboard/settings"
    delete "dashboard/news/:notification_id", :controller => 'dashboard', :action => :delete_notification, :as => 'delete_notification'
    get "dashboard/settings/edit", :controller => 'dashboard', :action => :edit_settings
    get "dashboard/settings/edit_password", :controller => 'dashboard', :action => 'edit_password'
    get "search", :controller => "search", :action => :search
    get "match", :controller => "search", :action => :match
    get "landing_page/index", :as => :landing_page
    post "bookmark/:klu_id", :controller => "bookmarks", :action => "create", :as => "create_bookmark"
    post "messages/:receiver_id", :controller => 'messages', :action => 'create', :as => 'create_message'
    get 'messages/:receiver_id/new', :controller => 'messages', :action => 'new', :as => 'new_message'
    get "tags/:tag", :controller => 'landing_page', :action => 'show_tagged_with', :as => 'tagged_with'
  end
  
  scope "(/:locale)", :locale => /de|en/ do
    resources :categories
    resources :klus do
      resources :ratings, :only => [:new, :create]
    end
  end
  
  scope "(/:locale)", :locale => /de|en/ do
    devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  end
  
  scope "(/:locale)", :locale => /en|de/ do
    resources :users do
      member do
        get 'no_kluuus'
        get 'kluuus'
      end
      resources :messages, :only => [:index, :show, :destroy, :update] do
        member do
          put "mark_read"
        end
      end
      resources :conversations, :only => [:index, :show, :destroy]
      resources :bookmarks, :only => [:index, :destroy]
      resources :follows, :only => [:destroy, :index]
      post "follow/:followed_id", :controller => "follows", :action => 'create', :as => "create_follow"
      resource :account do
        member do
          delete 'destroy_portrait'
          get 'preferences/edit', :action => 'edit_preferences'
          get 'preferences/show', :action => 'show_preferences'
          get 'password/edit', :action => 'edit_password'
        end
      end
      resources :klus do
        resources :klu_images
      end
      resources :status_updates do
        resources :comments
      end
      namespace :balance do
        resource :account
        resources :check_in_orders, :only => [:new, :create, :destroy]
      end
    end
  end
  
  namespace :admin do
    resources :users
    resources :categories
    resources :klus
    resources :video_servers
    get "dashboard/index"
  end
  
  post "ipn", :controller => 'paypal_payments', :action => 'create'
  resources :paypal_payments
  
  

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "landing_page#index"
  

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
