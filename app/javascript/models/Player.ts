import { Roll } from './Roll';
import { User } from './User';

export interface Player {
    id: number
    user: User
    ordering: number
    orderingRoll: Roll
}

export function playerName(player: Player) {
    return player.user.name
}
