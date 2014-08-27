Rails.application.routes.draw do
  resource :session, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create]

  resources :listings
  get 'my_listings', to: 'listings#my_listings'

  root to: "static_pages#home", as: "home"
end
