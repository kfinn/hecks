export enum NewDevelopmentCardAction {
    CreateDevelopmentCardPurchase = 'DevelopmentCardPurchase#create'
}

export enum DevelopmentCardAction {
    CreateMonopolyCardPlay = 'MonopolyCardPlay#create',
    CreateKnightCardPlay = 'KnightCardPlay#create'
}

export interface DevelopmentCard {
    id: number
    name: string
    developmentCardActions: DevelopmentCardAction[]
}
