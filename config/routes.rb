Rails.application.routes.draw do

  # Chat
  mount ActionCable.server => '/cable'
  resources :chatrooms
  resources :messages

  # Contacts
  resources :contacts, except: [:new, :create, :show]
  get "contacts/search", to: "contacts#search"

  # Admin
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # Events
  resources :events, except: [:index] do
    get 'attend', to: "events#attend"
    get 'addcontactbook', to: "events#addcontactbook"
  end

  get 'events', to: "events#search", as: 'search'
  
  # Attendances
  resources :attendances, only: [:destroy] do
    collection do
      get 'dashboard', to: "attendances#dashboard"
    end
  end
 
  # LinkedIn sign in/sign up
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}

  # Profile page
  resources :users, only: [:show]
  
  root to: 'pages#home'
  
end
