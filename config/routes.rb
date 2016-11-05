Rails.application.routes.draw do
  devise_for :users

  resources :groups, only: [:index, :show]

  root to: "groups#index"
end
