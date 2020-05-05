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
    }
}

export default function CornerSvg({ corner }: { corner: Corner }) {
    const action = CORNER_ACTIONS[corner.actions[0]]
    const onClick = () => {
        const asyncCreateInitialSettlement = async () => {
            try {
                await action(corner)
            } catch (error) {
                console.log(error.response)
            }
        }

        asyncCreateInitialSettlement()
    }

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
        onClick={action ? onClick : null}
        className={classNames.join(' ')}
    />
}
