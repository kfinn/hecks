import { Resource } from './Resource';

export enum BankOfferAction {
    CreateBankTrade = 'BankTrade#create'
}

export interface BankOffer {
    resourceToGive: Resource
    resourceToGiveCountRequired: number
    bankOfferActions: BankOfferAction[]
}
