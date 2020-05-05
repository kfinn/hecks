class InitialSetupTurn < Turn
    belongs_to :settlement, optional: true
    belongs_to :road, optional: true

    validates :player, uniqueness: true

    def can_create_initial_settlement?
        settlement.nil? && current?
    end

    def can_create_initial_road?
        settlement.present? && road.nil? && current?
    end

    def current?
        game.current_turn == self
    end

    def build_next_turn
        if player.next_player.initial_setup_turn.blank?
            InitialSetupTurn.new(game: game, player: player.next_player)
        else
            InitialSecondSetupTurn.new(game: game, player: player)
        end
    end
end
