import React from 'react';
import Api from '../models/Api';
import { Corner, CornerAction } from '../models/Corner';
import { positionToScreenX, positionToScreenY } from '../models/Position';
import { TERRITORY_RADIUS } from './TerritorySvg';

function cornerCenterX(corner: Corner) {
    return positionToScreenX(corner) * 2 * TERRITORY_RADIUS
}

function cornerCenterY(corner: Corner) {
    return positionToScreenY(corner) * 2 * TERRITORY_RADIUS
}

const CORNER_ACTIONS = {
    [CornerAction.CreateInitialSettlement]: async ({ id }: Corner) => {
        return await Api.post(`corners/${id}/initial_settlement.json`)
    },
    [CornerAction.CreateInitialSecondSettlement]: async ({ id }: Corner) => {
        return await Api.post(`corners/${id}/initial_second_settlement.json`)
    },
    [CornerAction.CreateSettlementPurchase]: async ({ id }: Corner) => {
        return await Api.post(`corners/${id}/settlement_purchase.json`)
    }
}

export default function CornerSvg({ corner }: { corner: Corner }) {
    const action = CORNER_ACTIONS[corner.cornerActions[0]]
    const onClick = action ? (() => {
        const asyncOnClick = async () => {
            try {
                await action(corner)
            } catch (error) {
                console.log(error.response)
            }
        }

        asyncOnClick()
    }) : null

    let classNames = ['corner']
    if (corner.settlement) {
        classNames.push('with-settlement')
    }
    if (action) {
        classNames.push('has-action')
    }

    return <circle
        cx={cornerCenterX(corner)}
        cy={cornerCenterY(corner)}
        r="5"
        onClick={onClick}
        className={classNames.join(' ')}
    />
}
