Rails.application.routes.draw do
  get "posts/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "static_pages#top"

  resources :groups, param: :uuid, only: [ :new, :create, :show ] do
    member do
      get :confirmation
    end
    resources :shops, only: [ :new, :create, :destroy ]
    resources :votes, only: [ :new, :create, :index ]
    resources :answers, only: [ :new, :create, :index ]
    resources :group_schedule_dates, only: [ :index, :create ]
    resources :user_schedules, only: [ :new, :create ]
  end

  namespace :api do
    get "ogp", to: "ogp#show"
  end
end
