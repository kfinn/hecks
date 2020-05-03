import React from 'react';
import { Territory, ProductionTerritory } from '../models/Territory';
import _ from 'lodash';

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


export interface TerritorySvgProps {
    territory: Territory
}

export default function TerritorySvg({ territory }: TerritorySvgProps) {
    let productionNumberValue = null
    const productionTerritory = territory as ProductionTerritory
    if (productionTerritory.productionNumber) {
        productionNumberValue = productionTerritory.productionNumber.value
    }

    return (
        <React.Fragment>
            <polygon points={territoryPolygonPoints(territory)} fill="white" stroke="black" />
            <text x={territoryCenterX(territory)} y={territoryCenterY(territory)} textAnchor="middle" dominantBaseline="middle">
                {territory.terrain.name}
                {productionNumberValue ? ` (${productionNumberValue})` : ''}
            </text>
        </React.Fragment>
    )
}
