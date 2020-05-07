import { Road } from "./Road";
import { Corner } from './Corner';

export enum BorderAction {
    CreateInitialRoad = 'InitialRoad#create',
    CreateInitialSecondRoad = 'InitialSecondRoad#create',
    CreateRoadPurchase = 'RoadPurchase#create'
}

export interface Border {
    id: number
    x: number
    y: number
    road?: Road
    corners: Corner[]
    borderActions: BorderAction[]
}
