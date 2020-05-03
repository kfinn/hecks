import { Roll } from './Roll';

export interface Player {
    id: number
    name: string
    ordering: number
    orderingRoll: Roll
}
