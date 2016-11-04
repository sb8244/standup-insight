Rails.application.routes.draw do
  devise_for :users

  resources :groups, only: [:index]

  root to: "groups#index"
end
