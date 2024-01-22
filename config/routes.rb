require 'sidekiq/web'

Rails.application.routes.draw do
  get 'oauths/oauth'
  get 'oauths/callback'
  get 'hello/index', to: 'hello#index'
  if Rails.env.development? || Rails.env.test?
    mount Sidekiq::Web => "/sidekiq"
  end
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  resources :password_resets, only: [:new, :create, :edit, :update]
  post 'line_events', to: 'line_events#recieve'
  delete 'line_events', to: 'line_events#unconnect'
  post 'google_login_api/callback', to: 'google_login_api#callback'
  resources :formats, only: %i[new create]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post "oauth/callback", to: "oauths#callback"
  get "oauth/callback", to: "oauths#callback"
  get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider

  resources :families, only: %i[show edit update destroy] do
    resources :users, only: %i[destroy] do
      resource :line_associates, only: %i[new create destroy]
    end
    resource :user_profile, only: %i[show edit update]
    resources :categories, only: %i[ index new create edit update destroy ] do
      resources :tasks
    end
    resources :task_users, only: %i[create destroy]
    resources :notices, only: %i[create index show destroy] do
      get :show_approval_request
    end
    resources :records, only: %i[ index new create destroy ] do
      patch :increment, on: :member
      patch :decrement, on: :member
      get :task_index, on: :member
    end
    get :configuration
    get :invitation
    get :advanced_configuration
    post :approve, to: 'approval_requests#approve', on: :member
    post :refuse, to: 'approval_requests#refuse', on: :member
  end
  resource :family_profile, only: %i[show edit update]
  resource :invited, controller: :invited_users, only: %i[new create]

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  post 'login_as_guest', to: 'user_sessions#login_as_guest'
  # Defines the root path route ("/")
  # root "articles#index"
  root "home#top"
end
