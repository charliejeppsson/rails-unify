Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources :events do
    get 'attend', to: "events#attend"
    get 'checkin', to: "events#checkin"
  end

  resources :attendances, only: [:destroy] do
    collection do
      get 'dashboard', to: "attendances#dashboard"
    end
  end

  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}

  # get '/auth/:provider/callback', to: 'omniauth_callbacks#callback', as: 'oauth_callback'
  # get '/auth/failure', to: 'oauth#failure', as: 'oauth_failure'

  root to: 'pages#home'

end
