export enum DiscardRequirementAction {
    CreateDiscard = 'Discard#create'
}

export interface DiscardRequirement {
    id: number
    resourceCardsCount: number
    actions: DiscardRequirementAction[]
}
