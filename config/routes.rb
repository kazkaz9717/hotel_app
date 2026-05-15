Rails.application.routes.draw do
  get "reservations/index"
  get "reservations/new"
  get "reservations/create"
  get "reservations/destroy"
  get "rooms/index"
  get "rooms/new"
  get "rooms/create"
  get "rooms/show"
  get "rooms/edit"
  get "rooms/update"
  get "rooms/destroy"
  get "rooms/search"
  get "users/new"
  get "users/create"
  get "users/show"
  get "users/edit"
  get "users/update"
  get "users/account"
  get "users/edit_account"
  get "users/update_account"
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
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

  resources :reservations, only: [:new, :create, :index, :destroy]
end