VoiceRepublic::Application.routes.draw do

  post 'api/talk/:id/messages' => 'api/messages#create'
  put 'api/talk/:id' => 'api/talks#update'
  get 'api/users'    => 'api/users#index'

  namespace 'api' do
    resources :social_shares, only: [:create]
  end

  scope "(/:locale)", :locale => /de|en/ do
    get "dashboard", :controller => "dashboard", :action => :index
    get "dashboard/settings"
    get "dashboard/venues"
    get "dashboard/settings/edit", :controller => 'dashboard', :action => :edit_settings
    get "dashboard/settings/edit_password", :controller => 'dashboard', :action => 'edit_password'
    get "search", :controller => "search", :action => :search
    get "landing_page/index", :as => :landing_page
    # TODO remove
    get "tags/:tag", :controller => 'search', :action => 'tagged_with', :as => 'tagged_with'
  end

  scope "(/:locale)", :locale => /de|en/ do
    get 'venues/tags' => 'venues#tags'
    resources :venues do
      resources :talks
      resources :participations, :only => [:index, :create, :destroy]
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

  resources :users, :only => [:update, :show] do
    member do
      get 'welcome'
      get 'venues' # venues_user_path
    end
    resource :account do
      member do
        get 'preferences/edit', :action => 'edit_preferences'
        get 'preferences/show', :action => 'show_preferences'
        get 'password/edit', :action => 'edit_password'
      end
    end
  end

  resource :embed_talk, :only => :show

  root :to => "landing_page#index"

  # match ':controller(/:action(/:id))(.:format)'

end
