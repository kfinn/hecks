export enum NewDevelopmentCardAction {
    CreateDevelopmentCardPurchase = 'DevelopmentCardPurchase#create'
}

export enum DevelopmentCardAction {
    CreateMonopolyPlay = 'MonopolyCardPlay#create'
}

export interface DevelopmentCard {
    id: number
    name: string
    developmentCardActions: DevelopmentCardAction[]
}
