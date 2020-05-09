class KnightCardPlay
    include ActiveModel::Model
    attr_accessor :development_card

    validates :development_card, presence: true
    validate :development_card_must_be_knight

    delegate :player, to: :development_card
    delegate :current_turn, to: :player

    def save!
        ApplicationRecord.transaction do
            raise ApplicationRecord::RecordInvalid.new(self) unless valid?
            robber_move_requirement.save!
            update_development_card!
        end
    end

    private

    def development_card_must_be_knight
        errors[:development_card] << 'is not a knight card' unless development_card.knight?
    end

    def development_card_must_be_playable
        errors[:base] << 'player cannot play this development card now' unless development_card.can_play?(current_turn)
    end

    def robber_move_requirement
        @robber_move_requirement ||= current_turn.robber_move_requirements.build
    end

    def update_development_card!
        development_card.update! played_during_turn: current_turn
    end
end
