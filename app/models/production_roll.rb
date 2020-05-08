class ProductionRoll
    include ActiveModel::Model
    attr_accessor :player

    delegate :game, :current_repeating_turn, to: :player

    validates :current_repeating_turn, presence: true
    validate :player_must_be_able_to_create_production_roll

    def save!
        raise ActiveRecord::RecordInvalid.new(self) unless valid?
        ApplicationRecord.transaction do
            roll.save!
            discard_requirements.each(&:save!)
            current_repeating_turn.save!
            collect_resources!
        end
    end

    private

    def player_must_be_able_to_create_production_roll
        errors[:player] << 'cannot create production roll' unless player.can_create_production_roll?
    end

    def collect_resources!
        if production_number.present?
            updated_players_by_id = Hash.new { |hash, player_id| hash[player_id] = game.players.find(player_id) }
            game.territories.without_robber.where(production_number_id: production_number.id).includes(:settlements).each do |territory|
                if territory.resource.present?
                    territory.settlements.each do |settlement|
                        player = updated_players_by_id[settlement.player.id]
                        player.collect_resource(territory.resource, settlement.resource_cards_per_production_roll)
                    end
                end
            end
            updated_players_by_id.values.each(&:save!)
        end
    end

    def roll
        @roll ||= current_repeating_turn.build_roll
    end

    def discard_requirements
        unless instance_variable_defined?(:@discard_requirements)
            if roll.value != 7
                @discard_requirements = []
            else
                @discard_requirements = game.players.with_more_than_seven_resource_cards.map do |player_to_discard|
                    player_to_discard.discard_requirements.build(turn: current_repeating_turn)
                end
            end
        end
        @discard_requirements
    end

    def production_number
        unless instance_variable_defined?(:@production_number)
            @production_number = ProductionNumber.find_by(value: roll.value)
        end
        @production_number
    end
end
