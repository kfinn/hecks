import React from 'react';
import { Corner } from '../models/Corner';
import { TERRITORY_RADIUS } from './TerritorySvg';
import { positionToScreenX, positionToScreenY } from '../models/Position';
import Api from '../models/Api';

function cornerCenterX(corner: Corner) {
    return positionToScreenX(corner) * 2 * TERRITORY_RADIUS
}

function cornerCenterY(corner: Corner) {
    return positionToScreenY(corner) * 2 * TERRITORY_RADIUS
}

export default function CornerSvg({ corner }: { corner: Corner }) {
    const createInitialSettlement = () => {
        const asyncCreateInitialSettlement = async () => {
            await Api.post(`corners/${corner.id}/initial_settlement.json`)
        }

        asyncCreateInitialSettlement()
    }

    return <circle
        cx={cornerCenterX(corner)}
        cy={cornerCenterY(corner)}
        r="5"
        onClick={createInitialSettlement}
        className={`corner ${corner.settlement ? 'with-settlement' : ''}`}
    />
}
