class InitialSecondSetupTurn < Turn
    belongs_to :settlement, optional: true
    belongs_to :road, optional: true

    validates :player, uniqueness: true

    def can_create_initial_second_settlement?
        settlement.nil? && current?
    end

    def can_create_initial_second_road?
        settlement.present? && road.nil? && current?
    end

    def current?
        game.current_turn == self
    end

    def build_next_turn
        if player.previous_player.initial_second_setup_turn.blank?
            InitialSecondSetupTurn.new(game: game, player: player.previous_player)
        else
            self
        end
    end
end
