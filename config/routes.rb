Rails.application.routes.draw do
  devise_for :users

  resources :groups, only: [:index, :show]
  resources :answers, only: [:create]
  resources :meetings, only: [:show] do
    member do
      get "destroy", as: :finish
    end
  end

  root to: "groups#index"
end
