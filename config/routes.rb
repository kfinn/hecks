Rails.application.routes.draw do
  get 'game_starts/create'
  devise_for :users
  root to: 'home#show'
  get 'home/show'

  resources :games, only: [:create, :show] do
    resource :game_preview, only: :show
    resource :players, only: :create
  end

  namespace :api do
    namespace :v1 do
      resources :borders, only: [] do
        resource :initial_road, only: :create
        resource :initial_second_road, only: :create
        resource :road_purchase, only: :create
        resource :road_building_road, only: :create
      end

      resources :corners, only: [] do
        resource :initial_settlement, only: :create
        resource :initial_second_settlement, only: :create
        resource :settlement_purchase, only: :create
        resource :city_upgrade_purchase, only: :create
      end

      resource :current_user, only: :update

      resources :development_cards, only: [] do
        resource :knight_card_play, only: :create
        resource :monopoly_card_play, only: :create
        resource :road_building_card_play, only: :create
        resource :year_of_plenty_card_play, only: :create
      end

      resources :discard_requirements, only: [] do
        resource :discard, only: :create
      end

      resources :games, only: :show do
        resources :bank_offers, only: [] do
          resources :bank_trades, only: :create
        end
        resource :current_player, only: :update
        resources :development_card_purchases, only: :create
        resource :game_start, only: :create
        resources :player_offers, only: :create
        resources :production_rolls, only: :create
        resources :repeating_turn_ends, only: :create
        resources :special_build_phases, only: :create
        resources :special_build_phase_turn_ends, only: :create
      end

      resources :players, only: [] do
        resources :robberies, only: :create
      end

      resources :player_offers, only: [] do
        resource :player_offer_response, only: :create
      end

      resources :player_offer_responses, only: [] do
        resource :player_trade, only: :create
      end

      resources :territories, only: [] do
        resources :robber_moves, only: :create
      end
    end
  end
end
