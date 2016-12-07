Rails.application.routes.draw do

  root 'locations#index', as: 'home', via: :all

  get "admin", to: "admin/locations#index"

  resources :password_requests, only: [:create, :new]
  resources :password_resets, only: [:create, :new]

  get "verify/:token", to: "users#verification", as: :account_verification
  get "/pages/:page" => "pages#show"
  get "/home" => "pages#show"

  controller :sessions do
    get  'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :locations do
    member do
      post :change
    end
    resources :meals, only: [:show] do
      resources :reviews
    end
  end

  resources :users, only: [:create, :new] do
    resources :orders, only: [:destroy, :show, :index, :edit] do
      resources :line_items, only: [:create, :destroy, :show, :index]
      member do
        post :place
        get :details
      end
      resources :line_items, only: [:create, :delete, :show, :index]
    end
  end
  



  namespace :admin do

    get 'pos/:location_name', to: 'pos#index', as: 'pos_index'
    get 'pos/:location_id/:order_id/deliver', to: 'pos#deliver', as: 'pos_deliver'
    get 'pos/:location_id/:order_id/cancel', to: 'pos#cancel', as: 'pos_cancel'
    get 'pos/:location_id/:order_id/show', to: 'pos#show', as: 'pos_show'

    resources :locations do
      get 'reports', to: 'reports#show', as: 'reports_show'
      resources :meals
      resources :inventory_items, only: [:index]
      resources :inventory_items, only: [], shallow: true  do
        member do
          patch :increase_quantity
          patch :decrease_quantity
        end
      end
    end

    resources :ingredients do
      resources :inventory_items, only: [:index]
    end

    resources :meals do
      member do
        patch :change_status
      end
      resources :recipe_items
    end

  end


  # get "sessions/destroy"
  # get "sessions/create"
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
