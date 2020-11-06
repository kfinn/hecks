import { Roll } from "./Roll";

export enum DiceAction {
    CreateProductionRoll = 'ProductionRoll#create'
}

export interface Dice {
    latestRoll: Roll
    diceActions: DiceAction[]
}
