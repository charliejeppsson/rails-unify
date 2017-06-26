Rails.application.routes.draw do

  # Real-time chat with ActionCable
  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
  resources :chatrooms
  resources :messages

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources :events, except: [:index] do

    get 'attend', to: "events#attend"
    get 'checkin', to: "events#checkin"
  end

  get 'events', to: "events#search", as: 'search'

  resources :attendances, only: [:destroy] do
    collection do
      get 'dashboard', to: "attendances#dashboard"
    end
  end

  # LinkedIn sign in/sign up
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}

  root to: 'pages#home'

  # Profile page
  resources :users, only: [:show]

end
