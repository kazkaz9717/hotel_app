Rails.application.routes.draw do
  root "rooms#index"

  get    "/signup",  to: "users#new"
  post   "/signup",  to: "users#create"
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"

  resources :users, only: [:show, :edit, :update] do
    collection do
      get  :account
      get  :edit_account
      patch :update_account
    end
  end

  resources :rooms do
    collection do
      get :search
    end
  end

  resources :reservations, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
    collection do
      post :confirm
    end
  end
end