class Discard
    include ActiveModel::Model
    attr_accessor :discard_requirement, :brick_cards_count, :grain_cards_count, :lumber_cards_count, :ore_cards_count, :wool_cards_count

    delegate :player, to: :discard_requirement

    validate :discard_requirement_must_be_pending
    validate :player_must_have_specified_cards

    def save!
        ApplicationRecord.transaction do
            raise ActiveRecord::RecordInvalid.new(self) unless valid?
            update_player!
            discard_requirement.complete!
        end
    end

    private

    def discard_requirement_must_be_pending
        errors[:discard_requirement] << 'must be pending' unless discard_requirement.pending?
    end

    def player_must_have_specified_cards
        Resource.all.each do |resource|
            if player.send(resource.attribute_name) < send(resource.attribute_name)
                errors[resource.attribute_name] << 'player must have enough cards'
            end
        end
    end

    def update_player!
        Resource.all.each do |resource|
            resources_to_discard = send(resource.attribute_name)
            if resources_to_discard > 0
                player.discard_resource(
                    resource,
                    send(resource.attribute_name)
                )
            end
        end
        player.save!
    end
end
