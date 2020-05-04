import { Player } from './Player';
import { Territory } from './Territory';
import { Corner } from './Corner';

export interface Game {
    id: number
    startedAt: string
    territories: Territory[]
    corners: Corner[]
    players: Player[]
}

export function gameIsStarted({ startedAt }: Game) {
    return !!startedAt
}
