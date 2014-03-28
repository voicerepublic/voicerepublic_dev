VoiceRepublic::Application.routes.draw do
  
  post '/api/talk/:id/messages', to: 'api/messages#create'
  put  '/api/talk/:id',          to: 'api/talks#update'
  get  '/api/users',             to: 'api/users#index'

  namespace 'api' do
    resources :social_shares, only: [:create]
  end

  post '/search',              to: 'search#create'
  get  '/search/:page/*query', to: 'search#show'

  # this looks fancy, i know, but what it basically provides
  # is handy shortcut to link to talks without the nesting
  # venue and then redirect to the nested path
  #
  # it makes the rendering of different kind of resources, like
  # in the search results, less painful
  nested_talk = ->(params, req) do 
    talk = Talk.find(params[:id])
    "/venues/#{talk.venue_id}/talks/#{talk.id}"
  end
  get  '/talk/:id', to: redirect(nested_talk), as: 'talk'

  # --- THE ENTRIES ABOVE ARE CONSOLIDATED, THE ENTRIES BELOW ARE NOT ---

  scope "(/:locale)", :locale => /de|en/ do
    get "dashboard", :controller => "dashboard", :action => :index
    get "dashboard/settings"
    get "dashboard/venues"
    get "dashboard/settings/edit", :controller => 'dashboard', :action => :edit_settings
    get "dashboard/settings/edit_password", :controller => 'dashboard', :action => 'edit_password'
    get "landing_page/index", :as => :landing_page
    # TODO remove
    get "tags/:tag", :controller => 'search', :action => 'tagged_with', :as => 'tagged_with'
  end

  scope "(/:locale)", :locale => /de|en/ do
    get 'venues/tags' => 'venues#tags'
    resources :venues do
      resources :comments, only: [:create]
      resources :talks
      resources :participations, :only => [:index, :create, :destroy]
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

  resources :users, :only => [:update, :show, :edit] do
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
