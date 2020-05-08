class Robbery
    include ActiveModel::Model
   attr_accessor :robbing_player, :player_to_rob

    validates :robbing_player, :player_to_rob, presence: true
    validate :robbing_player_must_be_able_to_rob_player_to_rob

    def save!
        raise ActiveRecord::RecordInvalid.new(self) unless valid?
        ApplicationRecord.transaction do
            if resource
                player_to_rob.discard_resource(resource)
                robbing_player.collect_resource(resource)
                player_to_rob.save!
                robbing_player.save!
                robbing_player.current_repeating_turn.update! robbed_player: player_to_rob
            end
        end
    end

    private

    def robbing_player_must_be_able_to_rob_player_to_rob
        errors[:base] << 'cannot rob this player' unless robbing_player.can_rob_player? player_to_rob
    end

    def resource
        unless instance_variable_defined?(:@resource)
            available_resources = Resource.all.flat_map do |resource|
                Array.new(player_to_rob.resource_cards_count(resource), resource)
            end
            @resource = available_resources.sample
        end
        @resource
    end
end
