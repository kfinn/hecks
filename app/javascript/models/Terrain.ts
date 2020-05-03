export enum TerrainId {
    Desert = 'desert',
    Fields = 'fields',
    Pasture = 'pasture',
    Forest = 'forest',
    Mountains = 'mountains',
    Hills = 'hills'
}

export interface ProductionTerrain {
    id: TerrainId.Fields | TerrainId.Pasture | TerrainId.Forest | TerrainId.Mountains | TerrainId.Hills
    name: string
}

export interface DesertTerrain {
    id: TerrainId.Desert
    name: string
}

export type Terrain = ProductionTerrain | DesertTerrain
