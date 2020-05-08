class ActionCollection
    SUBCOLLECTIONS = [
        :border_actions,
        :corner_actions,
        :territory_actions,
        :player_actions,
        :bank_offer_actions,
        :player_offer_actions,
        :player_offer_agreement_actions
    ]

    SINGULAR_SUBCOLLECTIONS = [
        :dice_actions,
        :discard_requirement_actions,
        :pending_discard_requirement_actions,
        :new_player_offer_actions,
        :new_development_card_actions
    ]

    class EmptyActionCollection
        include Singleton

        EMPTY_ACTIONS = [].freeze
        EMPTY_HASH = {}.freeze

        class EmptyActionSubcollection
            include Singleton
            include Enumerable

            delegate :each, to: :state

            def state
                EMPTY_HASH
            end

            def [](_key)
                EMPTY_ACTIONS
            end
        end

        SUBCOLLECTIONS.each do |subcollection_name|
            define_method(subcollection_name) do
                EmptyActionSubcollection.instance
            end
        end

        SINGULAR_SUBCOLLECTIONS.each do |singular_subcollection_name|
            define_method(singular_subcollection_name) do
                EMPTY_ACTIONS
            end
        end

        def merge(other)
            other
        end
    end

    def self.none
        EmptyActionCollection.instance
    end

    class ActionSubcollection
        include Enumerable
        delegate :[], :each, to: :state

        private

        def state
            @state ||= Hash.new { |hash, key| hash[key] = Set.new }
        end
    end

    SUBCOLLECTIONS.each do |subcollection_name|
        define_method(subcollection_name) do
            unless instance_variable_defined?("@#{subcollection_name}")
                instance_variable_set("@#{subcollection_name}", ActionSubcollection.new)
            end
            instance_variable_get("@#{subcollection_name}")
        end
    end

    SINGULAR_SUBCOLLECTIONS.each do |singular_subcollection_name|
        define_method(singular_subcollection_name) do
            unless instance_variable_defined?("@#{singular_subcollection_name}")
                instance_variable_set("@#{singular_subcollection_name}", Set.new)
            end
            instance_variable_get("@#{singular_subcollection_name}")
        end
    end

    def merge(other)
        ActionCollection.new.tap do |merged|
            SUBCOLLECTIONS.each do |subcollection_name|
                merged_subcollection = merged.send(subcollection_name)
                [self, other].each do |collection|
                    collection.send(subcollection_name).each do |key, value|
                        merged_subcollection[key] << value
                    end
                end
            end

            SINGULAR_SUBCOLLECTIONS.each do |singular_subcollection_name|
                merged_singular_actions = merged.send(singular_subcollection_name)
                [self, other].each do |collection|
                    collection.send(singular_subcollection_name).each { |action| merged_singular_actions << action }
                end
            end
        end
    end
end
