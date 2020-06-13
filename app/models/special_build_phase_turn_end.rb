class SpecialBuildPhaseTurnEnd
    include ActiveModel::Model
    attr_accessor :player

    delegate :game, to: :player

    validate :player_must_be_able_to_end_special_build_phase_turn

    def save!
        ApplicationRecord.transaction do
            raise ActiveRecord::RecordInvalid.new(self) unless valid?
            game.end_turn!
        end
    end

    private

    def player_must_be_able_to_end_special_build_phase_turn
        errors[:player] << 'cannot end special build phase turn' unless player.can_end_special_build_phase_turn?
    end
end
