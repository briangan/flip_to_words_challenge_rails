Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  match "/flip_letters/:letter", to: "flip_to_words/flip_letters#show", via: [ :get ], as: "flip_letter"
  match "/flip_letters/:letter", to: "flip_to_words/flip_letters#destroy", via: [ :delete ], as: "delete_flip_letter"
  match "/flip_letters", to: "flip_to_words/flip_letters#update", via: [ :put, :patch, :post ], as: "update_flip_letter" # allows new to create also
  get "/flip_letters", to: "flip_to_words/flip_letters#index", as: "flip_letters"

  post "/flip_to_words_challenge/verify", to: "flip_to_words/challenge#verify", as: "verify_flip_to_words_challenge"

  # Test pages
  get "/test_account_page", to: "home#test_account_page", as: "test_account_page"

  # Defines the root path route ("/")
  root "home#index"
end
