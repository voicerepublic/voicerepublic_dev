Rails.application.routes.draw do

  extend ApplicationHelper

  resources :tag_bundles, only: :show

  # a bunch of redirects
  scope 'r' do
    get 'md',       to: redirect(blog_url('/how-to-format-text-with-markdown'))
    get 'terms',    to: redirect(blog_url('/terms-of-use'))
    get 'username', to: redirect('/support/username') # TODO change to blog
  end

  get 'pages/:action' => 'pages'

  # TODO these will probably have to goe
  get 'support/:action', controller: 'support'
  get 'support', to: 'support#index'

  get "/pricing", to: 'purchases#index', as: 'pricing'
  resources :purchases, only: [ :index, :new, :create, :show ] do
    get 'express', on: :new
  end

  # in case someone bookmarked '/talks'
  get 'talks', to: redirect('explore')

  get 'explore', to: 'explore#index'

  # be nice, have some redirects for deprecated urls
  get 'explore/live',     to: redirect('/explore')
  get 'explore/popular',  to: redirect('/explore')
  get 'explore/featured', to: redirect('/explore')
  get 'explore/recent',   to: redirect('/explore')
  get 'explore/upcoming', to: redirect('/explore')

  resources :uploads, only: [ :new, :create ]

  post '/xhr/talk/:id/messages', to: 'xhr/messages#create'
  get  '/xhr/users',             to: 'xhr/users#index'

  namespace 'xhr' do
    resources :social_shares, only: [:create]
    resources :tags, only: [:index]
  end

  namespace 'api' do
    resources :talks, only: [:index]
    resources :uploads, only: [ :create ]
    resources :bookmarks, only: [ :index ]
    resources :users, only: [ :show ]
  end
  devise_scope :user do
    post "/api/sessions", to: "api/sessions#create"
  end


  post '/search',              to: 'search#create'
  get  '/search/:page/',       to: redirect('explore') # empty search
  get  '/search/:page/*query', to: 'search#show'

  # this looks fancy, i know, but what it basically provides
  # is handy shortcut to link to talks without the nesting
  # venue and then redirect to the nested path
  #
  # it makes the rendering of different kind of resources, like
  # in the search results, less painful
  nested_talk = ->(params, req) do
    talk = Talk.find_by(uri: params[:id])
    talk ||= Talk.find_by(id: params[:id])
    talk ? "/talks/#{talk.to_param}" : '/404'
  end
  get  '/talk/:id', to: redirect(nested_talk)
  # TODO delete this line
  # get  '/venues/:venue_id/talks/:id', to: redirect(nested_talk), as: :venue_talk

  # --- THE ENTRIES ABOVE ARE CONSOLIDATED, THE ENTRIES BELOW ARE NOT ---

  resources :talks, except: 'index'  do
    resources :reminders, only: [:create]
  end

  resources :series, except: :index do
    resources :comments, only: [:create]
    resources :participations, only: [:index, :create, :destroy]
  end
  get '/venues/:id', to: redirect(->(params, req) { '/series/'+params[:id] })

  resources :reminders, only: [:show, :destroy]

  devise_scope :user do
    delete "/users/sign_out" => "devise/sessions#destroy"
  end

  devise_for(:users,
             controllers: {
               omniauth_callbacks: "users/omniauth_callbacks",
               sessions: "users/sessions",
               registrations: "users/registrations"
             })

  resources :users, only: [:update, :show, :edit] do
    resources :reminders, only: [:index]
  end

  get '/onboard', to: 'users#onboard'


  scope 'embed' do
    # old school
    get ':id', to: 'embed/talks#show', as: 'embed'
    # new school
    get 'talks/:id', to: 'embed/talks#show', as: 'embed_talk'
    get 'series/:id', to: 'embed/series#show', as: 'embed_series'
  end


  get "root/index"
  root :to => "root#index"

  # match ':controller(/:action(/:id))(.:format)'

  # Match exceptions
  # http://railscasts.com/episodes/53-handling-exceptions-revised?view=asciicast
  match '(errors)/:status', to: 'errors#show', constraints: {status: /\d{3}/}, via: :all

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
