import React from 'react';
import { Border, BorderAction } from '../models/Border';
import { TERRITORY_RADIUS } from './TerritorySvg';
import { positionToScreenX, positionToScreenY } from '../models/Position';
import Api from '../models/Api';

function borderCenterX(border: Border) {
    return positionToScreenX(border) * 2 * TERRITORY_RADIUS
}

function borderCenterY(border: Border) {
    return positionToScreenY(border) * 2 * TERRITORY_RADIUS
}

const BORDER_ACTIONS = {
    [BorderAction.CreateInitialRoad]: async ({ id }: Border) => {
        return await Api.post(`borders/${id}/initial_road.json`)
    },
    [BorderAction.CreateInitialSecondRoad]: async ({ id }: Border) => {
        return await Api.post(`borders/${id}/initial_second_road.json`)
    }
}

export default function BorderSvg({ border }: { border: Border }) {
    const action = BORDER_ACTIONS[border.borderActions[0]]
    const onClick = action ? (() => {
        const asyncOnClick = async () => {
            try{
                await action(border)
            } catch (error) {
                console.log(error.response)
            }
        }

        asyncOnClick()
    }) : null

    const classNames = ['border']
    if (border.road) {
        classNames.push('with-road')
    }
    if (action) {
        classNames.push('has-action')
    }

    return <rect
        x={borderCenterX(border) - 4}
        y={borderCenterY(border) - 4}
        width="8"
        height="8"
        onClick={onClick}
        className={classNames.join(' ')}
    />
}
