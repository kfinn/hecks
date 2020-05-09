class YearOfPlentyCardPlay
    include ActiveModel::Model
    attr_accessor :development_card, :resource_1_id, :resource_2_id

    validates :development_card, :resource_1, :resource_2, presence: true
    validate :development_card_must_be_year_of_plenty
    validate :development_card_must_be_playable

    delegate :game, :player, to: :development_card
    delegate :current_turn, to: :player

    def resource_1
        @resource_1 ||= Resource.find(resource_1_id)
    end

    def resource_2
        @resource_2 ||= Resource.find(resource_2_id)
    end

    def save!
        ApplicationRecord.transaction do
            raise ActiveRecord::RecordInvalid.new(self) unless valid?
            update_player!
            update_development_card!
        end
    end

    private

    def development_card_must_be_year_of_plenty
        errors[:development_card] << 'is not a year of plenty card' unless development_card.year_of_plenty?
    end

    def development_card_must_be_playable
        errors[:base] << 'player cannot play this development card now' unless development_card.can_play?(current_turn)
    end

    def update_player!
        [resource_1, resource_2].each do |resource|
            player.collect_resource(resource)
        end
        player.save!
    end

    def update_development_card!
        development_card.update! played_during_turn: current_turn
    end
end
