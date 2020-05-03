import { ProductionNumber } from './ProductionNumber';
import { DesertTerrain, ProductionTerrain, TerrainId } from './Terrain';

export function territoryIsDesert(territory: Territory) {
    return territory.terrain.id == TerrainId.Desert
}

export interface ProductionTerritory {
    id: number
    x: number
    y: number
    terrain: ProductionTerrain
    productionNumber: ProductionNumber
}

export interface DesertTerritory {
    id: number
    x: number
    y: number
    terrain: DesertTerrain
}

export type Territory = ProductionTerritory | DesertTerritory
