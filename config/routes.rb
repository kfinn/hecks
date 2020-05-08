Rails.application.routes.draw do
  get 'game_starts/create'
  devise_for :users
  root to: 'home#get'
  get 'home/get'

  resources :games, only: [:create, :show]

  namespace :api do
    namespace :v1 do
      resource :current_user, only: :update
      resources :games, only: :show do
        resources :bank_offers, only: [] do
          resources :bank_trades, only: :create
        end
        resource :current_player, only: :update
        resource :game_start, only: :create
        resources :player_offers, only: :create
        resources :production_rolls, only: :create
        resources :repeating_turn_ends, only: :create
      end
      resources :corners, only: [] do
        resource :initial_settlement, only: :create
        resource :initial_second_settlement, only: :create
        resource :settlement_purchase, only: :create
        resource :city_upgrade_purchase, only: :create
      end
      resources :borders, only: [] do
        resource :initial_road, only: :create
        resource :initial_second_road, only: :create
        resource :road_purchase, only: :create
      end
      resources :territories, only: [] do
        resources :robber_moves, only: :create
      end
      resources :players, only: [] do
        resources :robberies, only: :create
      end
      resources :discard_requirements, only: [] do
        resource :discard, only: :create
      end
      resources :player_offers, only: [] do
        resource :player_offer_agreement, only: :create
      end
      resources :player_offer_agreements, only: [] do
        resource :player_trade, only: :create
      end
    end
  end
end
