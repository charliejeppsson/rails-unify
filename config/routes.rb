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

  # LinkedIn sign in/sign up
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}

  root to: 'pages#home'

  # Profile page
  get 'users/:id/profile', to: 'users#show'

end
