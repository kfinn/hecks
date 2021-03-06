export enum TerrainId {
    Desert = 'desert',
    Fields = 'fields',
    Pasture = 'pasture',
    Forest = 'forest',
    Mountains = 'mountains',
    Hills = 'hills'
}

type ProductionTerrainId = TerrainId.Fields | TerrainId.Forest | TerrainId.Hills | TerrainId.Mountains | TerrainId.Pasture

export interface ProductionTerrain {
    id: ProductionTerrainId
}

export interface DesertTerrain {
    id: TerrainId.Desert
}

export type Terrain = ProductionTerrain | DesertTerrain
