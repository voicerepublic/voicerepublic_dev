Kluuu2::Application.routes.draw do
  
  post "fayeproxy" => "fayeproxy#publish"

  scope "(/:locale)", :locale => /de|en/ do
    get "txt/agb"
    get "txt/tou"
    get "dashboard", :controller => "dashboard", :action => :index
    get "dashboard/contacts"
    get "dashboard/bookmarks"
    get "dashboard/news"
    get "dashboard/matches"
    get "dashboard/settings"
    get "dashboard/ping"
    get "dashboard/venues"
    get "dashboard/settings/edit", :controller => 'dashboard', :action => :edit_settings
    get "dashboard/settings/edit_password", :controller => 'dashboard', :action => 'edit_password'
    get "search", :controller => "search", :action => :search
    get "match", :controller => "search", :action => :match
    get "landing_page/index", :as => :landing_page
    # TODO remove
    post "bookmark/:klu_id", :controller => "bookmarks", :action => "create", :as => "create_bookmark"
    post "messages/:receiver_id", :controller => 'messages', :action => 'create', :as => 'create_message'
    get 'messages/:receiver_id/new', :controller => 'messages', :action => 'new', :as => 'new_message'
    get "tags/:tag", :controller => 'search', :action => 'tagged_with', :as => 'tagged_with'
    # TODO cleanup
    post "chats/venue/:id", :controller => 'chats', :action => 'post_group_chat', :as => 'group_chat'
    post "chats/venue/:id/info", :controller => 'chats', :action => 'post_host_info', :as => 'group_chat_info'
    post "chats/:one/:two", :controller => 'chats', :action => 'create', :as => 'post_chat'
    get "chats/:user_id/new", :controller => 'chats', :action => 'new', :as => 'new_chat'
    delete "chats/:one/:two", :controller => 'chats', :action => 'destroy', :as => 'destroy_chat'
  end

  scope "(/:locale)", :locale => /de|en/ do
    get 'venues/tags' => 'venues#tags'
    resources :venues do
      # move out into a separate controller
      member do
        post 'end_event'
        delete 'remove_recording'
      end
      post 'join_venue', :action => 'join_venue', :as => "join"
      delete 'unjoin_venue', :action => 'unjoin_venue', :as => 'unjoin' 
      resources :articles
    end
    resources :articles, only: [] do
      resources :comments, only: [:create]
    end
  end
  
  scope "(/:locale)", :locale => /de|en/ do
    devise_scope :user do
      delete "/users/sign_out" => "devise/sessions#destroy"
    end
  end
  
  devise_for(:users,
             controllers: {  
               omniauth_callbacks: "users/omniauth_callbacks",
               sessions: "users/sessions",
               registrations: "users/registrations"
             })

  scope "(/:locale)", :locale => /en|de/ do
    resources :participations, :only => [:index, :create, :destroy]
    resources :users, :only => [:update, :show] do
      member do
        get 'welcome'
        get 'venues' # venues_user_path
      end
      resource :account do
        member do
          delete 'destroy_portrait'
          get 'preferences/edit', :action => 'edit_preferences'
          get 'preferences/show', :action => 'show_preferences'
          get 'password/edit', :action => 'edit_password'
        end
      end
    end
  end
  
  root :to => "landing_page#index"

  # match ':controller(/:action(/:id))(.:format)'

end
