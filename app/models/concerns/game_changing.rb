module GameChanging
    extend ActiveSupport::Concern

    included do
        after_commit :notify_game_changed!
    end

    def notify_game_changed!
        game.changed!
    end
end
