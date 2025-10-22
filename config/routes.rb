Rails.application.routes.draw do
  get "webhooks/stripe"
  get "subscriptions/new"
  get "subscriptions/create"
  get "subscriptions/destroy"
  get "watchlist_items/create"
  get "watchlist_items/update"
  get "watchlist_items/destroy"
  get "media_items/index"
  get "media_items/show"
  get "media_items/search"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
