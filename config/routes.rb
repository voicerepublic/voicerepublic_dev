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

  get 'venues/tags' => 'venues#tags'
  resources :venues do
    resources :comments, only: [:create]
    resources :talks
    resources :participations, only: [:index, :create, :destroy]
  end

  devise_scope :user do
    delete "/users/sign_out" => "devise/sessions#destroy"
  end

  devise_for(:users,
             controllers: {
               omniauth_callbacks: "users/omniauth_callbacks",
               sessions: "users/sessions",
               registrations: "users/registrations"
             })

  resources :users, only: [:update, :show, :edit]

  resource :embed_talk, only: [ :show, :create ]

  get "landing_page/index", as: :landing_page
  root :to => "landing_page#index"

  # match ':controller(/:action(/:id))(.:format)'

  # Match exceptions
  # http://railscasts.com/episodes/53-handling-exceptions-revised?view=asciicast
  match '(errors)/:status', to: 'errors#show', constraints: {status: /\d{3}/}, via: :all

  get '/upgrade_browser', to: 'errors#upgrade_browser'

end
