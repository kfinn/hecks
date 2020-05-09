import { Roll } from './Roll';
import { User } from './User';
import { Color } from './Color';

export enum PlayerAction {
    CreateRobbery = 'Robbery#create'
}

export interface Player {
    id: number
    name: string
    user: User
    ordering: number
    orderingRoll?: Roll
    color: Color
    totalResourceCardsCount: number
    playerActions: PlayerAction[]
}

export function playerName(player: Player) {
    return player.name
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

export function playerTotalResourceCardsCount({ totalResourceCardsCount }: Player) {
    return totalResourceCardsCount
}
