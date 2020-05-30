class Army
    def initialize(player)
        @player = player
    end

    attr_reader :player

    def size
        @size ||= player.played_knight_cards.size
    end

    def since
        @since ||= player.played_knight_cards.most_recently_played_at
    end
end
