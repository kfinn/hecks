class Roll < ApplicationRecord
    POSSIBLE_DIE_VALUES = [1, 2, 3, 4, 5, 6]

    after_initialize :roll!

    def value
        return die_1_value + die_2_value
    end

    def roll!
        self.die_1_value ||= random_die_value
        self.die_2_value ||= random_die_value
    end

    def random_die_value
        rand(6) + 1
    end
end
