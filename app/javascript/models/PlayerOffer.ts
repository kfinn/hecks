import { PlayerOfferAgreement } from './PlayerOfferAgreement';

export enum NewPlayerOfferAction {
    CreatePlayerOffer = 'PlayerOffer#create'
}

export enum PlayerOfferAction {
    CreatePlayerOfferAgreement = 'PlayerOfferAgreement#create'
}

export interface NewPlayerOffer {
    brickCardsCountFromOfferingPlayer: number
    grainCardsCountFromOfferingPlayer: number
    lumberCardsCountFromOfferingPlayer: number
    oreCardsCountFromOfferingPlayer: number
    woolCardsCountFromOfferingPlayer: number
    brickCardsCountFromAgreeingPlayer: number
    grainCardsCountFromAgreeingPlayer: number
    lumberCardsCountFromAgreeingPlayer: number
    oreCardsCountFromAgreeingPlayer: number
    woolCardsCountFromAgreeingPlayer: number
}

interface ExistingPlayerOffer {
    id: number
    playerName: string
    playerOfferAgreements: PlayerOfferAgreement[]
    playerOfferActions: PlayerOfferAction[]
}

export type PlayerOffer = NewPlayerOffer & ExistingPlayerOffer
