import { ProductionNumber } from './ProductionNumber';
import { DesertTerrain, ProductionTerrain } from './Terrain';

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
