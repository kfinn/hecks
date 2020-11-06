export interface TurnStatus {
    actor: string
    actorIsCurrentPlayer: boolean
    description: string
}

export interface WinnerStatus {
    winner: string
    winnerIsCurrentPlayer: boolean
    winnerSettlementScore: number
    winnerLargestArmyScore: number
    winnerLongestRoadScore: number
    winnerVictoryPointCardScore: number
}

export type Status = TurnStatus | WinnerStatus
