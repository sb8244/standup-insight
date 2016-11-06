Rails.application.routes.draw do
  devise_for :users

  resources :groups, only: [:index, :show]
  resources :answers, only: [:create]
  resources :meetings, only: [:show]

  root to: "groups#index"
end
