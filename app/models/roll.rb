class Roll < ApplicationRecord
    after_initialize :roll!

    def value
        return die_1_value + die_2_value
    end

    def roll!
        self.die_1_value ||= 2 #random_die_value
        self.die_2_value ||= 5 #random_die_value
    end

    def random_die_value
        rand(6) + 1
    end
end
