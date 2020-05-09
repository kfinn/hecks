class RobberMove
    include ActiveModel::Model
    attr_accessor :player, :territory

    delegate :game, :current_repeating_turn, to: :player
    delegate :latest_robber_move_requirement, to: :current_repeating_turn

    validate :player_must_be_able_to_move_robber
    validate :robber_must_move_to_a_new_territory

    def save!
        ApplicationRecord.transaction do
            raise ActiveRecord::RecordInvalid.new(self) unless valid?
            update_game!
            update_latest_robber_move_requirement!
        end
    end

    private

    def player_must_be_able_to_move_robber
        errors[:player] << 'cannot move robber' unless latest_robber_move_requirement.needs_moved_to_territory?
    end

    def update_game!
        game.update! robber_territory: territory
    end

    def update_latest_robber_move_requirement!
        latest_robber_move_requirement.update! moved_to_territory: territory
    end

    def robber_must_move_to_a_new_territory
        errors[:territory] << 'cannot be current robber territory' if territory == game.robber_territory
    end
end
