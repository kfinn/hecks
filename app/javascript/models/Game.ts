import { Player } from './Player';
import { Territory } from './Territory';
import { Corner } from './Corner';
import { Border } from './Border';

export interface Game {
    id: number
    startedAt: string
    territories: Territory[]
    corners: Corner[]
    borders: Border[]
    players: Player[]
}

export function gameIsStarted({ startedAt }: Game) {
    return !!startedAt
}
