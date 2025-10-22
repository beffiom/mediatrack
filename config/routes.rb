Rails.application.routes.draw do
  devise_for :users

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

  # Stripe webhooks
  post "stripe/webhook", to: "webhooks#stripe"

  # Root
  root "media_items#index"
end
