VoiceRepublic::Application.routes.draw do

  post '/xhr/talk/:id/messages', to: 'xhr/messages#create'
  put  '/xhr/talk/:id',          to: 'xhr/talks#update'
  get  '/xhr/users',             to: 'xhr/users#index'

  namespace 'xhr' do
    resources :social_shares, only: [:create]
    resources :tags, only: [:index]
  end

  if Settings.api.try(:enabled)
    namespace 'api' do
      resources :talks, only: [:index]
    end
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
    "/talks/#{talk.id}"
  end
  get  '/talk/:id', to: redirect(nested_talk)
  get  '/venues/:venue_id/talks/:id', to: redirect(nested_talk), as: :venue_talk

  # --- THE ENTRIES ABOVE ARE CONSOLIDATED, THE ENTRIES BELOW ARE NOT ---

  resources :talks

  resources :venues do
    resources :comments, only: [:create]
    resources :participations, only: [:index, :create, :destroy]
  end

  resources :talks, only: [:index] do
    collection do
      get :live
      get :popular
      get :featured
      get :recent
      get :upcoming
    end
    resources :reminders, only: [:create]
  end

  resources :reminders, only: [:destroy]

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

  # old school
  resource :embed_talk, only: :show
  # new school
  get 'embed/:id', to: 'embed_talks#show', as: 'embed'

  get "landing_page/index", as: :landing_page
  root :to => "landing_page#index"

  # match ':controller(/:action(/:id))(.:format)'

  # Match exceptions
  # http://railscasts.com/episodes/53-handling-exceptions-revised?view=asciicast
  match '(errors)/:status', to: 'errors#show', constraints: {status: /\d{3}/}, via: :all

  get '/upgrade_browser', to: 'errors#upgrade_browser'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
