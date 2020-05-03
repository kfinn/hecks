import _ from 'lodash';
import React from 'react';
import { Territory } from '../models/Territory';
import TerritorySvg from './TerritorySvg';

export interface BoardSvgProps {
    territories: Territory[]
}

export default function BoardSvg({ territories }: BoardSvgProps) {
    return (
        <React.Fragment>
            <h2>Board</h2>
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="-250 -250 500 500">
                {
                    _.map(territories, (territory) => <TerritorySvg key={territory.id} territory={territory} />)
                }
            </svg>
        </React.Fragment>
    )
}
