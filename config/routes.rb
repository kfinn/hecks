Rails.application.routes.draw do
  get 'game_starts/create'
  devise_for :users
  root to: 'home#get'
  get 'home/get'

  resources :games, only: [:create, :show]

  namespace :api do
    namespace :v1 do
      resources :games, only: [] do
        resource :start, only: :create
      end
    end
  end
end
