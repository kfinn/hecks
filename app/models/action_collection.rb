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

        def dice_actions
            EMPTY_ACTIONS
        end
    end

    def self.none
        EmptyActionCollection.instance
    end

    def border_actions
        @border_actions ||= Hash.new { |hash, key| hash[key] = [] }
    end

    def corner_actions
        @corner_actions ||= Hash.new { |hash, key| hash[key] = [] }
    end

    def dice_actions
        @dice_actions ||= Set.new
    end
end
