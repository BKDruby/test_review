require "sidekiq/web"

Rails.application.routes.draw do
  get "listings/index"
  devise_for :users
  resources :listings do
    resources :reviews
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  mount Sidekiq::Web => "/sidekiq"

  # Defines the root path route ("/")
  devise_scope :user do
    root to: "listings#index"
  end
end
