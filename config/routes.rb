Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :events, except: [:index] do
    get 'attend', to: "events#attend"
  end

  get 'events', to: "events#search", as: 'search'

  resources :attendances, only: [:destroy] do
    collection do
      get 'dashboard', to: "attendances#dashboard"
    end
  end

  devise_for :users
  root to: 'pages#home'

end
