class RepeatingTurnEnd
    include ActiveModel::Model
    attr_accessor :player

    delegate :game, to: :player

    validate :player_must_be_able_to_end_turn

    def save!
        raise ActiveRecord::RecordInvalid(self) unless valid?
        ApplicationRecord.transaction do
            game.end_turn!
        end
    end

    private

    def player_must_be_able_to_end_turn
        errors[:player] << 'cannot end turn' unless player.can_end_turn?
    end
end
