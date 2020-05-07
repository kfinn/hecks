export enum ResourceId {
    Brick = 'brick',
    Grain = 'grain',
    Lumber = 'lumber',
    Ore = 'ore',
    Wool = 'wool'
}

export interface Resource {
    id: ResourceId
}

const NAMES_BY_RESOURCE_ID = {
    [ResourceId.Brick]: 'Brick',
    [ResourceId.Grain]: 'Grain',
    [ResourceId.Lumber]: 'Lumber',
    [ResourceId.Ore]: 'Ore',
    [ResourceId.Wool]: 'Wool'
}

export function resourceIdName(resourceId: ResourceId) {
    return NAMES_BY_RESOURCE_ID[resourceId]
}
