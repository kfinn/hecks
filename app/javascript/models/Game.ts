import { Player } from './Player';
import { Territory } from './Territory';
import { Corner } from './Corner';
import { Border } from './Border';
import { Hand } from './Hand';
import { Dice } from './Dice';
import { Status } from './Status';

export interface Game {
    id: number
    startedAt: string
    status: Status
    territories: Territory[]
    corners: Corner[]
    borders: Border[]
    players: Player[]
    hand: Hand
    dice: Dice
}

export function gameIsStarted({ startedAt }: Game) {
    return !!startedAt
}
