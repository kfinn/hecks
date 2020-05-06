import { Roll } from './Roll';
import { User } from './User';
import { Color } from './Color';

export interface Player {
    id: number
    user: User
    ordering: number
    orderingRoll?: Roll
    color: Color
}

export function playerName(player: Player) {
    return player.user.name
}

export function playerColor(player: Player) {
    return player.color
}

export function playerOrderingRollDescription({ orderingRoll }: Player) {
    if (orderingRoll) {
        return `(${orderingRoll.die1Value}, ${orderingRoll.die2Value})`
    }
    return ''
}
