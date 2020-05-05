class ProductionRoll
    include ActiveModel::Model
    attr_accessor :player

    delegate :game, to: :player

    validate :player_must_be_current_player
end
