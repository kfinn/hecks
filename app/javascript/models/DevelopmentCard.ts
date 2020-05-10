export enum NewDevelopmentCardAction {
    CreateDevelopmentCardPurchase = 'DevelopmentCardPurchase#create'
}

export enum DevelopmentCardAction {
    CreateKnightCardPlay = 'KnightCardPlay#create',
    CreateMonopolyCardPlay = 'MonopolyCardPlay#create',
    CreateRoadBuildingCardPlay = 'RoadBuildingCardPlay#create',
    CreateYearOfPlentyCardPlay = 'YearOfPlentyCardPlay#create'
}

export interface DevelopmentCard {
    id: number
    name: string
    developmentCardActions: DevelopmentCardAction[]
}
