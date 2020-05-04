import { Roll } from './Roll';
import { User } from './User';

export interface Player {
    id: number
    user: User
    ordering: number
    orderingRoll?: Roll
}

export function playerName(player: Player) {
    return player.user.name
}

export function playerOrderingRollDescription({ orderingRoll }: Player) {
    if (orderingRoll) {
        return `(${orderingRoll.die1Value}, ${orderingRoll.die2Value})`
    }
    return ''
}
