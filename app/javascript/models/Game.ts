import { Player } from './Player';
import { Territory } from './Territory';
import { Corner } from './Corner';

export interface Game {
    id: number
    territories: Territory[]
    corners: Corner[]
    players: Player[]
}
