import React from 'react';
import _ from 'lodash';

interface Player {
    id: number
    name: string
}

interface ProductionNumber {
    value: number
    frequency: number
}

interface ProductionTerrain {
    id: string
    name: string
}

interface ProductionTerritory {
    id: number
    x: number
    y: number
    terrain: ProductionTerrain
    productionNumber: ProductionNumber
}

interface DesertTerrain {
    id: 'Desert'
    name: 'Desert'
}

interface DesertTerritory {
    id: number
    x: number
    y: number
    terrain: DesertTerrain
}

type Territory = ProductionTerritory | DesertTerritory

interface Game {
    territories: Territory[]
    players: Player[]
}

const HEX_SCALE = 50

function territoryCenterX({ x, y }: Territory) {
    return (x + y * Math.cos(2 * Math.PI / 3)) * 2 * HEX_SCALE
}

function territoryCenterY({ y }: Territory) {
    return (y * Math.sin(2 * Math.PI / 3)) * 2 * HEX_SCALE
}

function territoryPolygonPoints(territory: Territory) {
    const angles = _.map(_.range(6), (piThirds) => piThirds * Math.PI / 3)
    const normalizedPointPairs = _.map(angles, (angle) => {
        return [
            Math.sin(angle),
            Math.cos(angle)
        ]
    })
    const screenPoints = _.flatMap(normalizedPointPairs, ([x, y]) => {
        return [
            x * HEX_SCALE + territoryCenterX(territory),
            y * HEX_SCALE + territoryCenterY(territory)
        ]
    })
    const roundedScreenPoints = screenPoints.map(Math.round)
    return roundedScreenPoints.join(' ')
}

export default function Game(game: Game) {
    return (
        <div>
            <h1>Game</h1>
            <h2>Players</h2>
            <ul>
                {
                    _.map(game.players, ({ id, name }) => <li key={id}>{name}</li>)
                }
            </ul>
            <h2>Board</h2>
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="-250 -250 500 500">
                {
                    _.map(game.territories, (territory) => {
                        let productionNumberValue = null
                        const productionTerritory = territory as ProductionTerritory
                        if (productionTerritory && productionTerritory.productionNumber) {
                            productionNumberValue = productionTerritory.productionNumber.value
                        }

                        return (
                            <React.Fragment key={territory.id}>
                                <polygon points={territoryPolygonPoints(territory)} fill="white" stroke="black" />
                                <text x={territoryCenterX(territory)} y={territoryCenterY(territory)} textAnchor="middle" dominantBaseline="middle">
                                    {territory.terrain.name}
                                    { productionNumberValue ? ` (${productionNumberValue})` : '' }
                                </text>
                            </React.Fragment>
                        )
                    })
                }
            </svg>
        </div>
    )
}
