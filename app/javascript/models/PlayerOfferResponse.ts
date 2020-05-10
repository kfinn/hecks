export enum PlayerOfferResponseAction {
    CreatePlayerTrade = 'PlayerTrade#create'
}

export interface PlayerOfferResponse {
    id: number
    playerName: string
    agreeing: boolean
    playerOfferResponseActions: PlayerOfferResponseAction[]
}
