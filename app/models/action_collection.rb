class ActionCollection
    class EmptyActionCollection
        include Singleton

        EMPTY_ACTIONS = [].freeze

        class EmptyActionSubcollection
            include Singleton

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

        def bank_offer_actions
            EmptyActionSubcollection.instance
        end
    end

    def self.none
        EmptyActionCollection.instance
    end

    class ActionSubcollection
        delegate :[], to: :state

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
end
