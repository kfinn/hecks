class Roll < ApplicationRecord
    after_initialize :roll!, if: :needs_roll?

    def value
        return die_1_value + die_2_value
    end

    def roll!
        self.die_1_value = random_die_value
        self.die_2_value = random_die_value
    end

    def random_die_value
        rand(6) + 1
    end

    def needs_roll?
        die_1_value.blank? || die_2_value.blank?
    end
end
