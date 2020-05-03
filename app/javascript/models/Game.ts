import { Player } from './Player';
import { Territory } from './Territory';

export interface Game {
    territories: Territory[]
    players: Player[]
}
