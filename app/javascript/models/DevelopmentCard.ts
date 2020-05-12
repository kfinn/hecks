export enum NewDevelopmentCardAction {
    CreateDevelopmentCardPurchase = 'DevelopmentCardPurchase#create'
}

export enum DevelopmentCardAction {
    CreateKnightCardPlay = 'KnightCardPlay#create',
    CreateMonopolyCardPlay = 'MonopolyCardPlay#create',
    CreateRoadBuildingCardPlay = 'RoadBuildingCardPlay#create',
    CreateYearOfPlentyCardPlay = 'YearOfPlentyCardPlay#create'
}

interface DevelopmentCardBehavior {
    id: string
    description: string
}

export interface DevelopmentCard {
    id: number
    name: string
    developmentCardBehavior: DevelopmentCardBehavior
    developmentCardActions: DevelopmentCardAction[]
}

export function developmentCardDescription(developmentCard: DevelopmentCard) {
    return developmentCard.developmentCardBehavior.description
}
