import { Player } from './Player';
import { Territory } from './Territory';
import { Corner } from './Corner';
import { Border } from './Border';
import { Hand } from './Hand';

export interface Game {
    id: number
    startedAt: string
    territories: Territory[]
    corners: Corner[]
    borders: Border[]
    players: Player[]
    hand: Hand
}

export function gameIsStarted({ startedAt }: Game) {
    return !!startedAt
}
