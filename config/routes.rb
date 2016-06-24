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
    end
  end




  namespace :admin do

    get 'pos/:location_name', to: 'pos#index', as: 'pos_index'
    get 'pos/:location_id/:order_id/deliver', to: 'pos#deliver', as: 'pos_deliver'
    get 'pos/:location_id/:order_id/cancel', to: 'pos#cancel', as: 'pos_cancel'
    get 'pos/:location_id/:order_id/show', to: 'pos#show', as: 'pos_show'

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

end
