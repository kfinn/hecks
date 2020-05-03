import _ from 'lodash';
import React from 'react';
import { TerrainId } from '../models/Terrain';
import { ProductionTerritory, Territory, territoryIsDesert } from '../models/Territory';

const HEX_RADIUS = 50
const TERRAIN_ICON_RADIUS = HEX_RADIUS * 0.4

function territoryCenterX({ x, y }: Territory) {
    return (x + y * Math.cos(2 * Math.PI / 3)) * 2 * HEX_RADIUS
}

function territoryCenterY({ y }: Territory) {
    return (y * Math.sin(2 * Math.PI / 3)) * 2 * HEX_RADIUS
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
            x * HEX_RADIUS + territoryCenterX(territory),
            y * HEX_RADIUS + territoryCenterY(territory)
        ]
    })
    const roundedScreenPoints = screenPoints.map(Math.round)
    return roundedScreenPoints.join(' ')
}

const TERRAIN_ICONS_BY_TERRAIN_ID = {
    [TerrainId.Fields]: require('../images/grain.svg'),
    [TerrainId.Pasture]: require('../images/wool.svg'),
    [TerrainId.Forest]: require('../images/lumber.svg'),
    [TerrainId.Mountains]: require('../images/ore.svg'),
    [TerrainId.Hills]: require('../images/brick.svg')
}

export interface TerritorySvgProps {
    territory: Territory
}

function TerritoryIcon({ territory }: { territory: Territory }) {
    if (territoryIsDesert(territory)) {
        return null;
    }
    return <image
        x={territoryCenterX(territory) - TERRAIN_ICON_RADIUS}
        y={territoryCenterY(territory) - TERRAIN_ICON_RADIUS * 1.5}
        width={TERRAIN_ICON_RADIUS * 2}
        height={TERRAIN_ICON_RADIUS * 2}
        className={`terrain-icon ${territory.terrain.id}`}
        href={TERRAIN_ICONS_BY_TERRAIN_ID[territory.terrain.id]}
    />
}

export default function TerritorySvg({ territory }: TerritorySvgProps) {
    if (territoryIsDesert(territory)) {
        return <polygon points={territoryPolygonPoints(territory)} className={`territory ${territory.terrain.id}`} />
    }
    const productionTerritory = territory as ProductionTerritory

    return (
        <React.Fragment>
            <polygon points={territoryPolygonPoints(territory)} className={`territory ${territory.terrain.id}`} />
            <TerritoryIcon territory={territory} />
            <text
                x={territoryCenterX(territory)}
                y={territoryCenterY(territory) + TERRAIN_ICON_RADIUS * 0.25}
                textAnchor="middle"
                dominantBaseline="text-before-edge"
                className={(productionTerritory.productionNumber.frequency == 5) ? 'high-frequency' : ''}
            >
                {productionTerritory.productionNumber.value}
            </text>
        </React.Fragment>
    )
}
