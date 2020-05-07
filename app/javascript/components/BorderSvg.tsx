import React from 'react';
import { Border, BorderAction } from '../models/Border';
import { TERRITORY_RADIUS } from './TerritorySvg';
import { positionToScreenX, positionToScreenY } from '../models/Position';
import Api from '../models/Api';
import { colorClassName } from '../models/Color';
import { cornerCenterX, cornerCenterY } from './CornerSvg';

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
    },
    [BorderAction.CreateRoadPurchase]: async ({ id }: Border) => {
        return await Api.post(`borders/${id}/road_purchase.json`)
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
    const road = border.road
    if (road) {
        classNames.push(colorClassName(road.color))
    }
    if (action) {
        classNames.push('has-action')
    }

    const [corner1, corner2] = border.corners
    const corner1CenterX = cornerCenterX(corner1)
    const corner1CenterY = cornerCenterY(corner1)
    const corner2CenterX = cornerCenterX(corner2)
    const corner2CenterY = cornerCenterY(corner2)
    const dx = corner2CenterX - corner1CenterX
    const dy = corner2CenterY - corner1CenterY
    const distance = Math.sqrt((dx * dx) + (dy * dy))
    const rotationRadians = Math.atan2(dx, dy)

    return <path
        d={`
            M${corner1CenterX} ${corner1CenterY}
            m${Math.sin(rotationRadians) * 10} ${Math.cos(rotationRadians) * 10}
            l${Math.sin(rotationRadians + (Math.PI / 2)) * 2} ${Math.cos(rotationRadians + (Math.PI / 2)) * 2}
            l${Math.sin(rotationRadians) * (distance - 20)} ${Math.cos(rotationRadians) * (distance - 20)}
            l${Math.sin(rotationRadians + (Math.PI / 2)) * (-4)} ${Math.cos(rotationRadians + (Math.PI / 2)) * (-4)}
            l${Math.sin(rotationRadians)* (-(distance - 20))} ${Math.cos(rotationRadians) * (-(distance - 20))}
            z
        `}
        onClick={onClick}
        className={classNames.join(' ')}
    />
}
