Rails.application.routes.draw do

  get 'contacts/new'

  get 'contacts/create'

  get 'contacts/index'

  get 'contacts/show'

  get 'contacts/destroy'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources :events, except: [:index] do

    get 'attend', to: "events#attend"
    get 'addcontactbook', to: "events#addcontactbook"
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
