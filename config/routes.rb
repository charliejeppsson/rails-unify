Rails.application.routes.draw do

  resources :events do
    get 'attend', to: "events#attend"
  end

  resources :attendances, only: [:destroy] do
    collection do
      get 'dashboard', to: "attendances#dashboard"
    end
  end

  devise_for :users
  root to: 'pages#home'

end
