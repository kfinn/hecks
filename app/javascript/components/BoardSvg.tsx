import _ from 'lodash';
import React from 'react';
import { Game } from '../models/Game';
import BorderSvg from './BorderSvg';
import CornerSvg from './CornerSvg';
import HarborSvg from './HarborSvg';
import TerritorySvg from './TerritorySvg';

export interface BoardSvgProps {
    game: Game
}

export default function BoardSvg({ game }: BoardSvgProps) {
    return (
        <React.Fragment>
            <h2>Board</h2>
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="-235 -245 515 500">
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
