class ActionCollection
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

        def border_actions
            EmptyActionSubcollection.instance
        end

        def corner_actions
            EmptyActionSubcollection.instance
        end

        def territory_actions
            EmptyActionSubcollection.instance
        end

        def player_actions
            EmptyActionSubcollection.instance
        end

        def dice_actions
            EMPTY_ACTIONS
        end

        def discard_requirement_actions
            EMPTY_ACTIONS
        end

        def pending_discard_requirement_actions
            EMPTY_ACTIONS
        end

        def bank_offer_actions
            EmptyActionSubcollection.instance
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

    def border_actions
        @border_actions ||= ActionSubcollection.new
    end

    def corner_actions
        @corner_actions ||= ActionSubcollection.new
    end

    def territory_actions
        @territory_actions ||= ActionSubcollection.new
    end

    def player_actions
        @player_actions ||= ActionSubcollection.new
    end

    def dice_actions
        @dice_actions ||= Set.new
    end

    def bank_offer_actions
        @bank_offer_actions ||= ActionSubcollection.new
    end

    def pending_discard_requirement_actions
        @pending_discard_requirement_actions ||= Set.new
    end

    def merge(other)
        ActionCollection.new.tap do |merged|
            [:border_actions, :corner_actions, :territory_actions, :player_actions, :bank_offer_actions].each do |subcollection_name|
                merged_subcollection = merged.send(subcollection_name)
                [self, other].each do |collection|
                    collection.send(subcollection_name).each do |key, value|
                        merged_subcollection[key] << value
                    end
                end
            end

            [:dice_actions, :pending_discard_requirement_actions].each do |singular_subcollection_name|
                merged_singular_actions = merged.send(singular_subcollection_name)
                [self, other].each do |collection|
                    collection.send(singular_subcollection_name).each { |action| merged_singular_actions << action }
                end
            end
        end
    end
end
