import React from 'react';
import { Corner } from '../models/Corner';
import { TERRITORY_RADIUS } from './TerritorySvg';
import { positionToScreenX, positionToScreenY } from '../models/Position';

function cornerCenterX(corner: Corner) {
    return positionToScreenX(corner) * 2 * TERRITORY_RADIUS
}

function cornerCenterY(corner: Corner) {
    return positionToScreenY(corner) * 2 * TERRITORY_RADIUS
}


export default function CornerSvg({ corner }: { corner: Corner }) {
    return <circle cx={cornerCenterX(corner)} cy={cornerCenterY(corner)} r="5" />
}
