class InitialSetupTurn < Turn
    belongs_to :settlement, optional: true
    belongs_to :road, optional: true

    validates :player, uniqueness: true

    def description
        if settlement.blank?
            'build an initial settlement'
        else
            'build an initial road'
        end
    end

    def actions
        ActionCollection.new.tap do |action_collection|
            if can_create_initial_settlement?
                game.corners.available_for_settlement.each do |corner|
                    action_collection.corner_actions[corner] << 'InitialSettlement#create'
                end
            end

            if can_create_initial_road?
                settlement.borders.each do |border|
                    action_collection.border_actions[border] << 'InitialRoad#create'
                end
            end
        end
    end

    def can_create_initial_settlement?
        settlement.nil? && current?
    end

    def can_create_initial_road?
        settlement.present? && road.nil? && current?
    end

    def build_next_turn
        if player.next_player.initial_setup_turn.blank?
            InitialSetupTurn.new(game: game, player: player.next_player)
        else
            InitialSecondSetupTurn.new(game: game, player: player)
        end
    end
end
