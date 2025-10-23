Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  
  # User settings routes
  devise_scope :user do
    get 'settings/password/edit', to: 'users/registrations#update_password', as: :edit_password_settings
    patch 'settings/password', to: 'users/registrations#change_password', as: :change_password_settings
    patch 'settings/api_key', to: 'users/registrations#update_api_key', as: :update_api_key_settings
  end
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Media browsing and search
  resources :media_items, only: [:index, :show] do
    collection do
      get :search
    end
  end

  # Watchlist management
  resources :watchlist_items, only: [:create, :update, :destroy]

  # Subscriptions (Stripe checkout/management)
  resources :subscriptions, only: [:new, :create, :destroy]

  # Section pages
  get "movies", to: "media_items#movies"
  get "tv", to: "media_items#tv"
  get "anime", to: "media_items#anime"

  # Stripe webhooks
  post "stripe/webhook", to: "webhooks#stripe"

  # Root
  root "media_items#index"
end
