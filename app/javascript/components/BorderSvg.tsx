import React from 'react';
import { Border } from '../models/Border';
import { TERRITORY_RADIUS } from './TerritorySvg';
import { positionToScreenX, positionToScreenY } from '../models/Position';
import Api from '../models/Api';

function borderCenterX(border: Border) {
    return positionToScreenX(border) * 2 * TERRITORY_RADIUS
}

function borderCenterY(border: Border) {
    return positionToScreenY(border) * 2 * TERRITORY_RADIUS
}

export default function BorderSvg({ border }: { border: Border }) {
    const createInitialRoad = () => {
        const asyncCreateInitialRoad = async () => {
            await Api.post(`borders/${border.id}/initial_road.json`)
        }

        asyncCreateInitialRoad()
    }

    return <rect
        x={borderCenterX(border) - 4}
        y={borderCenterY(border) - 4}
        width="8"
        height="8"
        onClick={createInitialRoad}
        className={`border ${border.road ? 'with-road' : ''}`}
    />
}
