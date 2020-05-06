class InitialSecondSetupTurn < Turn
    belongs_to :settlement, optional: true
    belongs_to :road, optional: true

    validates :player, uniqueness: true

    def description
        if settlement.blank?
            'build a second initial settlement'
        else
            'build a second initial road'
        end
    end

    def actions
        ActionCollection.new.tap do |action_collection|
            if can_create_initial_second_settlement?
                game.corners.available_for_settlement.each do |corner|
                    action_collection.corner_actions[corner] << 'InitialSecondSettlement#create'
                end
            end

            if can_create_initial_second_road?
                settlement.borders.each do |border|
                    action_collection.border_actions[border] << 'InitialSecondRoad#create'
                end
            end
        end
    end

    def can_create_initial_second_settlement?
        settlement.nil? && current?
    end

    def can_create_initial_second_road?
        settlement.present? && road.nil? && current?
    end

    def build_next_turn
        if player.previous_player.initial_second_setup_turn.blank?
            InitialSecondSetupTurn.new(game: game, player: player.previous_player)
        else
            RepeatingTurn.new(game: game, player: player)
        end
    end
end
