class RobberMove
    include ActiveModel::Model
    attr_accessor :player, :territory

    delegate :game, to: :player

    validate :player_must_be_able_to_move_robber

    def save!
        ApplicationRecord.transaction do
            raise ActiveRecord::RecordInvalid.new(self) unless valid?
            update_game!
            update_turn!
        end
    end

    private

    def player_must_be_able_to_move_robber
        errors[:player] << 'cannot create move robber' unless player.can_move_robber?
    end

    def update_game!
        game.update! robber_territory: territory
    end

    def update_turn!
        player.current_repeating_turn.update!(
            robber_moved_at: Time.zone.now,
            robber_moved_to_territory: territory
        )
    end
end
