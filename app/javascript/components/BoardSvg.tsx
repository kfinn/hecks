import _ from 'lodash';
import React from 'react';
import { Game } from '../models/Game';
import CornerSvg from './CornerSvg';
import TerritorySvg from './TerritorySvg';

export interface BoardSvgProps {
    game: Game
}

export default function BoardSvg({ game }: BoardSvgProps) {
    return (
        <React.Fragment>
            <h2>Board</h2>
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="-250 -250 500 500">
                {
                    _.map(game.territories, (territory) => <TerritorySvg key={territory.id} territory={territory} />)
                }
                {
                    _.map(game.corners, (corner) => <CornerSvg key={corner.id} corner={corner} />)
                }
            </svg>
        </React.Fragment>
    )
}
