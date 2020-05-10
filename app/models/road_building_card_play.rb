class RoadBuildingCardPlay < ApplicationRecord
    include GameChanging
    belongs_to :development_card
    belongs_to :road_1, class_name: 'Road', optional: true
    belongs_to :road_2, class_name: 'Road', optional: true

    has_one :game, through: :development_card

    scope :incomplete, -> { where(road_2: nil) }

    validate :development_card_must_be_road_building
    validate :development_card_must_be_playable, on: :create

    before_create :play_development_card!

    def turn_description
        if road_1.blank?
            'use Road Building to build a road'
        else
            'use Road Building to build a second road'
        end
    end

    def completed?
        road_1.present? && road_2.present?
    end

    def next_road=(road)
        if self.road_1.blank?
            self.road_1 = road
        elsif self.road_2.blank?
            self.road_2 = road
        else
            raise 'no roads left'
        end
    end

    private

    def development_card_must_be_road_building
        errors[:development_card] << 'must be road building' unless development_card.road_building?
    end

    def development_card_must_be_playable
        errors[:base] << 'player cannot play this development card now' unless development_card.can_play?(development_card.player.current_turn)
    end

    def play_development_card!
        development_card.play!
    end
end
