import { Player } from './Player';
import { Territory } from './Territory';

export interface Game {
    id: number
    territories: Territory[]
    players: Player[]
}
