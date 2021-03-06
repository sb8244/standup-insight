Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :groups, only: [:index, :show]
  resources :answers, only: [:create]
  resources :meetings, only: [:show] do
    member do
      get "destroy", as: :finish
      get "finish_landing", as: :finish_landing
      get "prep", as: :prep
    end
  end

  root to: "groups#index"
end
