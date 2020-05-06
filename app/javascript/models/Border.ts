import { Road } from "./Road";

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
    borderActions: BorderAction[]
}
