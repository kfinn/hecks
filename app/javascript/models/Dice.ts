import { Roll } from "./Roll";

export enum DiceAction {
    CreateProductionRoll = 'ProductionRoll#create',
    EndRepeatingTurn = 'RepeatingTurnEnds#create',
    EndSpecialBuildPhaseTurn = 'SpecialBuildPhaseTurnEnds#create'
}

export interface Dice {
    latestRoll: Roll
    diceActions: DiceAction[]
}
