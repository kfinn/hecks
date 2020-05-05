module GameChanging
    extend ActiveSupport::Concern

    included do
        after_save :notify_game_changed!
        after_destroy :notify_game_changed!
    end

    def notify_game_changed!
        game.changed!
    end
end
