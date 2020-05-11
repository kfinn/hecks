import React from 'react';
import Api from '../models/Api';
import { Corner, CornerAction } from '../models/Corner';
import { positionToScreenX, positionToScreenY } from '../models/Position';
import { TERRITORY_RADIUS } from './TerritorySvg';
import { colorClassName } from '../models/Color';

export function cornerCenterX(corner: Corner) {
    return positionToScreenX(corner) * 2 * TERRITORY_RADIUS
}

export function cornerCenterY(corner: Corner) {
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
    },
    [CornerAction.CreateCityUpgradePurchase]: async ({ id }: Corner) => {
        return await Api.post(`corners/${id}/city_upgrade_purchase.json`)
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
    const settlement = corner.settlement
    if (settlement) {
        classNames.push(colorClassName(corner.settlement.color))
    }
    if (action) {
        classNames.push('has-action')
    }

    const sharedProps = {onClick, className: classNames.join(' ' ) }

    if (settlement) {
        if (settlement.isCity) {
            return <path
                d={`M${cornerCenterX(corner) - 9} ${cornerCenterY(corner) + 7} l0 -9 l5 -5 l5 5 l8 0 l0 9 z`}
                {...sharedProps}
            />
        } else {
            return <path
                d={`M${cornerCenterX(corner) - 5} ${cornerCenterY(corner) + 5} l0 -6 l5 -4 l5 4 l0 6 z`}
                {...sharedProps}
            />
        }
    } else {
        return <circle
            cx={cornerCenterX(corner)}
            cy={cornerCenterY(corner)}
            r="4"
            {...sharedProps}
        />
    }
}
