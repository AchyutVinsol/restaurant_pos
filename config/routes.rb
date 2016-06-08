Rails.application.routes.draw do

  #FIXME_AB: DONE make an admin route /admin
  root 'pages#show', as: 'home', via: :all, page: "home"

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

  namespace :admin do

    resources :locations do
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

  resources :users, only: [:create, :new]


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
