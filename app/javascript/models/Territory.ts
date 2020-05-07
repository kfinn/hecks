import { ProductionNumber } from './ProductionNumber';
import { DesertTerrain, ProductionTerrain, TerrainId } from './Terrain';

export function territoryIsDesert(territory: Territory) {
    return territory.terrain.id == TerrainId.Desert
}

export enum TerritoryAction {
    CreateRobberMove = 'RobberMove#create'
}

export interface ProductionTerritory {
    id: number
    x: number
    y: number
    terrain: ProductionTerrain
    productionNumber: ProductionNumber
    hasRobber: boolean
    territoryActions: TerritoryAction[]
}

export interface DesertTerritory {
    id: number
    x: number
    y: number
    terrain: DesertTerrain
    hasRobber: boolean
    territoryActions: TerritoryAction[]
}

export type Territory = ProductionTerritory | DesertTerritory
