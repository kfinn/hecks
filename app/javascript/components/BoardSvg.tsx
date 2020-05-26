import _ from 'lodash';
import React from 'react';
import { Game } from '../models/Game';
import BorderSvg from './BorderSvg';
import CornerSvg from './CornerSvg';
import HarborSvg from './HarborSvg';
import TerritorySvg, { territoryCenterX, territoryCenterY, TERRITORY_RADIUS } from './TerritorySvg';

export interface BoardSvgProps {
    game: Game
}

const BOARD_MARGIN = 105

export default function BoardSvg({ game }: BoardSvgProps) {
    const { territories } = game
    const territoryXs = _.map(territories, 'x')
    const territoryYs = _.map(territories, 'y')

    const minTerritoryX = _.min(territoryXs)
    const maxTerritoryX = _.max(territoryXs)
    const minTerritoryY = _.min(territoryYs)
    const maxTerritoryY = _.max(territoryYs)

    const widthBetweenTerritoryCenters = territoryCenterX({ x: maxTerritoryX, y: 0}) - territoryCenterX({ x: minTerritoryX, y: 0 })
    const heightBetweenTerritoryCenters = territoryCenterY({ x: 0, y: maxTerritoryY }) - territoryCenterY({ x: 0, y: minTerritoryY })

    const widthOfTerritories = widthBetweenTerritoryCenters + TERRITORY_RADIUS * 2
    const heightOfTerritories = heightBetweenTerritoryCenters + TERRITORY_RADIUS * 2

    const width = widthOfTerritories + BOARD_MARGIN
    const height = heightOfTerritories + BOARD_MARGIN

    const x = -width / 2
    const y = -height / 2

    return (
        <React.Fragment>
            <svg xmlns="http://www.w3.org/2000/svg" viewBox={`${x} ${y} ${width} ${height}`} className="board">
                {
                    _.map(game.harbors, (harbor) => <HarborSvg key={harbor.id} harbor={harbor} />)
                }
                {
                    _.map(game.territories, (territory) => <TerritorySvg key={territory.id} territory={territory} />)
                }
                {
                    _.map(game.borders, (border) => <BorderSvg key={border.id} border={border} />)
                }
                {
                    _.map(game.corners, (corner) => <CornerSvg key={corner.id} corner={corner} />)
                }
            </svg>
        </React.Fragment>
    )
}
