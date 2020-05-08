class MonopolyCardPlay
    include ActiveModel::Model
    attr_accessor :development_card, :resource_id

    validates :development_card, :resource, presence: true
    validate :development_card_must_be_monopoly
    validate :development_card_must_be_playable

    delegate :game, :player, to: :development_card
    delegate :current_turn, to: :player
    delegate :players, to: :game

    def resource
        @resource ||= Resource.find(resource_id)
    end

    def save!
        ApplicationRecord.transaction do
            raise ActiveRecord::RecordInvalid.new(self) unless valid?
            update_players!
            update_development_card!
        end
    end

    private

    def development_card_must_be_monopoly
        errors[:development_card] << 'is not a monopoly card' unless development_card.monopoly?
    end

    def development_card_must_be_playable
        errors[:base] << 'player cannot play this development card now' unless development_card.can_play?(current_turn)
    end

    def update_players!
        (players - [player]).each do |other_player|
            other_player_resources = other_player.resource_cards_count(resource)

            if other_player_resources > 0
                other_player.discard_resource(resource, other_player_resources)
                other_player.save!

                player.collect_resource(resource, other_player_resources)
            end
        end
        player.save!
    end

    def update_development_card!
        development_card.update! played_during_turn: current_turn
    end
end
