MealPlanner::Application.routes.draw do
  resources :lists do
    collection do
      post :remove
      post :add
    end
  end

  resources :user_foods do
    collection do
      get :search_for_select
      get :search
    end
  end

  resources :foods do
    collection do
      get :search_for_select
      get :search
    end
  end

  resources :usda_ndb_foods do
    collection do
      get :search_for_select
      get :search
    end
  end

  resources :receipts
  resources :stores
  resources :recipes
  resources :users do
    resources :recipes
  end

  resource :session do
    member do
      get :from_facebook
    end
  end
  
  resources :list_items

  match '/logout' => 'sessions#destroy', :as => :logout
  match '/login' => 'sessions#new', :as => :login
  match '/register' => 'users#create', :as => :register
  match '/signup' => 'users#new', :as => :signup
  match '/:controller(/:action(/:id))'
  root :to => "recipes#index"
end