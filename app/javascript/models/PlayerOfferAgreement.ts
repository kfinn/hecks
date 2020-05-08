export enum PlayerOfferAgreementAction {
    CreatePlayerTrade = 'PlayerTrade#create'
}

export interface PlayerOfferAgreement {
    id: number
    playerName: string
    playerOfferAgreementActions: PlayerOfferAgreementAction[]
}
