class ActionCollection
    class EmptyActionCollection
        include Singleton

        class EmptyActionSubcollection
            include Singleton

            EMPTY_ACTIONS = [].freeze

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
end
