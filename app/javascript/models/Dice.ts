import { Roll } from "./Roll";

export enum DiceAction {
    CreateProductionRoll = 'ProductionRoll#create',
    EndTurn = 'RepeatingTurnEnds#create'
}

export interface Dice {
    latestRoll: Roll
    diceActions: DiceAction[]
}
