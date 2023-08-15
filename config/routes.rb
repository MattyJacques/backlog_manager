Rails.application.routes.draw do
  # Defines the root path route ("/")
  root 'psn_accounts#index'

  devise_for :users

  resources :psn_accounts, except: %i[new edit create update destroy]
  resources :trophy_lists, except: %i[new edit create update destroy]
end
