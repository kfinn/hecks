import { HarborOffer } from './HarborOffer';
import { Corner } from './Corner';

export interface Harbor {
    id: number
    x: number
    y: number
    harborOffer: HarborOffer
    corners: Corner[]
}
