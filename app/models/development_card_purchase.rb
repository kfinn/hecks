class DevelopmentCardPurchase
    include ActiveModel::Model
    attr_accessor :player

    delegate :game, :current_repeating_turn, to: :player
    delegate :development_cards, to: :game

    validates :current_repeating_turn, presence: true
    validate :player_must_be_able_to_purchase_development_card
    validate :game_must_have_available_development_card

    def save!
        ApplicationRecord.transaction do
            raise ActiveRecord::RecordInvalid.new(self) unless valid?
            update_player!
            update_next_development_card!
        end
    end

    private

    def player_must_be_able_to_purchase_development_card
        errors[:player] << 'cannot purchase development card' unless player.can_purchase_development_card?
    end

    def game_must_have_available_development_card
        errors[:base] << 'no development cards left' unless development_cards.available_for_purchase.any?
    end

    def update_player!
        player.discard_resource Resource::GRAIN
        player.discard_resource Resource::ORE
        player.discard_resource Resource::WOOL
        player.save!
    end

    def update_next_development_card!
        game.development_cards.next_available.update!(
            player: player,
            purchased_during_turn: current_repeating_turn
        )
    end
end
