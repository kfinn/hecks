class RobberMoveRequirement < ApplicationRecord
    belongs_to :turn
    belongs_to :moved_to_territory, class_name: 'Territory', optional: true
    belongs_to :robbed_player, class_name: 'Player', optional: true

    validate :robbed_player_must_occupy_moved_to_territory

    delegate :player, to: :turn

    def robbable_players
        @robbable_players ||= (moved_to_territory&.players&.where&.not(id: player.id)) || []
    end

    def has_robbable_players?
        robbable_players.any?
    end

    def needs_moved_to_territory?
        moved_to_territory.blank?
    end

    def needs_robbed_player?
        has_robbable_players? && robbed_player.blank?
    end

    def can_rob_player?(player)
        robbable_players.include? player
    end

    private

    def robbed_player_must_occupy_moved_to_territory
        return unless robbed_player.present?
        errors[:robbed_player] << 'cannot rob this player' unless robbable_players.include? robbed_player
    end
end
