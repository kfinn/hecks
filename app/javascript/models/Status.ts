export interface TurnStatus {
    actor: string
    actorIsCurrentPlayer: boolean
    description: string
}

export interface WinnerStatus {
    winner: string
    winnerIsCurrentPlayer: boolean
}

export type Status = TurnStatus | WinnerStatus
