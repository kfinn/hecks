import { Road } from "./Road";

export enum BorderAction {
    CreateInitialRoad = 'InitialRoad#create',
    CreateInitialSecondRoad = 'InitialSecondRoad#create'
}

export interface Border {
    id: number
    x: number
    y: number
    road?: Road
    actions: BorderAction[]
}
