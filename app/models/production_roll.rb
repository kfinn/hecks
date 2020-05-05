class ProductionRoll
    include ActiveModel::Model
    attr_accessor :player

    delegate :game, :current_repeating_turn, to: :player

    validates :current_repeating_turn, presence: true
    validate :player_must_be_able_to_create_production_roll

    def save!
        raise ActiveRecord::RecordInvalid(self) unless valid?
        ApplicationRecord.transaction do
            roll.save!
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
            game.territories.where(production_number: production_number).includes(:settlements).each do |territory|
                if territory.resource.present?
                    territory.settlements.map(&:player).each do |player|
                        player.collect_resource(territory.resource)
                        player.save!
                    end
                end
            end
        end
    end

    def roll
        @roll ||= current_repeating_turn.build_roll
    end

    def production_number
        unless instance_variable_defined?(:@production_number)
            @production_number = ProductionNumber.find_by(value: roll.value)
        end
        @production_number
    end
end
