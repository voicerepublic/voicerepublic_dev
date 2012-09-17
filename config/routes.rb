Kluuu2::Application.routes.draw do
  
  scope "(/:locale)", :locale => /de|en/ do
    get "dashboard", :controller => "dashboard", :action => :index, :as => 'user_root'
  end

  match "(/:locale)/landing_page/index", :as => :landing_page
  
  scope "(/:locale)", :locale => /de|en/ do
    resources :categories
    resources :klus
  end
  
  scope "(/:locale)", :locale => /de|en/ do
    devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  end
  
  post "bookmark/:klu_id", :controller => "bookmarks", :action => "create", :as => "create_bookmark"
  
  scope "(/:locale)", :locale => /en|de/ do
    resources :users do
      member do
        get 'no_kluuus'
        get 'kluuus'
      end
      resources :bookmarks, :only => [:index, :destroy]
      resources :follows, :only => [:destroy, :index]
      post "follow/:followed_id", :controller => "follows", :action => 'create', :as => "create_follow"
      resource :account do
        member do
          delete 'destroy_portrait'
        end
      end
      resources :klus do
        resources :klu_images
      end
      resources :status_updates do
        resources :comments
      end
    end
  end
  
  namespace :admin do
    resources :users
    resources :categories
    resources :klus
    get "dashboard/index"
  end
  
  

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
