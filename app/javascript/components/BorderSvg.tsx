import React from 'react';
import Api from '../models/Api';
import { Border, BorderAction } from '../models/Border';
import { colorClassName } from '../models/Color';
import { cornerCenterX, cornerCenterY } from './CornerSvg';
import ConnectingLineSvg from './ConnectingLineSvg';

const BORDER_ACTIONS = {
    [BorderAction.CreateInitialRoad]: async ({ id }: Border) => {
        return await Api.post(`borders/${id}/initial_road.json`)
    },
    [BorderAction.CreateInitialSecondRoad]: async ({ id }: Border) => {
        return await Api.post(`borders/${id}/initial_second_road.json`)
    },
    [BorderAction.CreateRoadPurchase]: async ({ id }: Border) => {
        return await Api.post(`borders/${id}/road_purchase.json`)
    },
    [BorderAction.CreateRoadBuildingRoad]: async({ id }: Border) => {
        return await Api.post(`borders/${id}/road_building_road.json`)
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

    return <ConnectingLineSvg
        from={corner1}
        to={corner2}
        onClick={onClick}
        className={classNames.join(' ')}
    />
}
