import _ from 'lodash';
import React from 'react';
import BrickIcon from '../images/brick.svg';
import GrainIcon from '../images/grain.svg';
import LumberIcon from '../images/lumber.svg';
import OreIcon from '../images/ore.svg';
import WoolIcon from '../images/wool.svg';
import Api from '../models/Api';
import { Position, positionToScreenX, positionToScreenY } from '../models/Position';
import { TerrainId } from '../models/Terrain';
import { ProductionTerritory, Territory, TerritoryAction, territoryIsDesert } from '../models/Territory';


export const TERRITORY_RADIUS = 50
const HEX_RADIUS = 42
export const TERRAIN_ICON_RADIUS = HEX_RADIUS * 0.4

const PRODUCTION_TERRITORY_ROBBER_OFFSET_X = -HEX_RADIUS * 0.65
const PRODUCTION_TERRITORY_ROBBER_OFFSET_Y = -HEX_RADIUS * 0.35

const DESERT_TERRITORY_ROBBER_OFFSET_X = -8
const DESERT_TERRITORY_ROBBER_OFFSET_Y = -12

export function territoryCenterX(territory: Position) {
    return positionToScreenX(territory) * 2 * TERRITORY_RADIUS
}

export function territoryCenterY(territory: Position) {
    return positionToScreenY(territory) * 2 * TERRITORY_RADIUS
}

function territoryPolygonPoints(territory: Position) {
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
    return screenPoints.join(' ')
}

const TERRAIN_ICONS_BY_TERRAIN_ID = {
    [TerrainId.Fields]: GrainIcon,
    [TerrainId.Pasture]: WoolIcon,
    [TerrainId.Forest]: LumberIcon,
    [TerrainId.Mountains]: OreIcon,
    [TerrainId.Hills]: BrickIcon
}

export interface TerritorySvgProps {
    territory: Territory
}

function Robber({ territory, offsetX, offsetY }: { territory: Territory, offsetX: number, offsetY: number }) {
    return <path d="M0.0529519852,26.0234938 C0.226230209,25.2821084 2.20456723,23.7632076 5.98796305,21.4667914 C3.99721405,19.2763247 3.00183954,17.0960432 3.00183954,14.925947 C3.00183954,12.7558508 3.99721405,10.5889725 5.98796305,8.42531212 C5.14801645,6.62882108 4.81572162,5.10359626 4.99107856,3.84963764 C5.25411397,1.96869971 6.55979839,0.937278454 8.03510979,0.937278454 C9.51042119,0.937278454 10.7481294,1.95297145 10.9706886,3.84963764 C11.1190614,5.11408176 10.7667561,6.63930659 9.91377295,8.42531212 C11.940012,10.5820496 12.9531316,12.7489279 12.9531316,14.925947 C12.9531316,17.1029661 11.940012,19.2832476 9.91377295,21.4667914 C13.3156946,23.3800654 15.3473612,24.8989662 16.0087726,26.0234938 L0.0529519852,26.0234938 Z" transform={`translate(${territoryCenterX(territory) + offsetX}, ${territoryCenterY(territory) + offsetY})`} className="robber" />
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

const TERRITORY_ACTIONS = {
    [TerritoryAction.CreateRobberMove]: async ({ id }: Territory) => {
        return await Api.post(`territories/${id}/robber_moves.json`)
    }
}

export default function TerritorySvg({ territory }: TerritorySvgProps) {
    const action = TERRITORY_ACTIONS[territory.territoryActions[0]]
    const onClick = action ? (() => {
        const asyncOnClick = async () => {
            try {
                await action(territory)
            } catch (error) {
                console.log(error.response)
            }
        }

        asyncOnClick()
    }) : null
    const polygonClassName = ['territory', territory.terrain.id].join(' ')
    const sharedProps = {
        onClick,
        className: action ? 'has-action' : ''
    }

    if (territoryIsDesert(territory)) {
        return (
            <g {...sharedProps}>
                <polygon points={territoryPolygonPoints(territory)}  className={polygonClassName} />
                {territory.hasRobber ? <Robber territory={territory} offsetX={DESERT_TERRITORY_ROBBER_OFFSET_X} offsetY={DESERT_TERRITORY_ROBBER_OFFSET_Y} /> : null}
            </g>
        )
    }

    const productionTerritory = territory as ProductionTerritory

    return (
        <g {...sharedProps}>
            <polygon points={territoryPolygonPoints(territory)} className={polygonClassName} />
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
            {territory.hasRobber ? <Robber territory={territory} offsetX={PRODUCTION_TERRITORY_ROBBER_OFFSET_X} offsetY={PRODUCTION_TERRITORY_ROBBER_OFFSET_Y} /> : null}
        </g>
    )
}
