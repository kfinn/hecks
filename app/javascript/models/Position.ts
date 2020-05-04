export const TERRITORY_SCREEN_RADIUS = 0.5

const TERRITORY_SCREEN_HORIZONTAL_RADIUS = TERRITORY_SCREEN_RADIUS * Math.cos(Math.PI / 6)

const VERTICAL_CYCLE_HEIGHT = TERRITORY_SCREEN_RADIUS+ TERRITORY_SCREEN_RADIUS * Math.sin(Math.PI / 6)

export interface Position {
    x: number
    y: number
}

export function positionToScreenX({ x }: Position) {
    return (x / 4) * (TERRITORY_SCREEN_HORIZONTAL_RADIUS) * 2
}

export function positionToScreenY({ y }: Position) {
    const mod4 = ((y % 4) + 4) % 4
    const nearestTerritoryCenterY = ((y - mod4) / 4) * VERTICAL_CYCLE_HEIGHT

    if (mod4 == 0) {
        return nearestTerritoryCenterY
    } else if (mod4 == 1) {
        return nearestTerritoryCenterY + Math.sin(Math.PI / 6) * TERRITORY_SCREEN_RADIUS
    } else if (mod4 == 2) {
        return nearestTerritoryCenterY + Math.cos(Math.PI / 6) * TERRITORY_SCREEN_HORIZONTAL_RADIUS
    } else {
        return nearestTerritoryCenterY + TERRITORY_SCREEN_RADIUS
    }
}
