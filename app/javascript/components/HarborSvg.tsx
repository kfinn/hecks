import React from 'react';
import BrickIcon from '../images/brick.svg';
import GrainIcon from '../images/grain.svg';
import LumberIcon from '../images/lumber.svg';
import OreIcon from '../images/ore.svg';
import WoolIcon from '../images/wool.svg';
import { Harbor } from '../models/Harbor';
import { Position } from '../models/Position';
import { ResourceId } from '../models/Resource';
import { territoryCenterX, territoryCenterY } from './TerritorySvg';
import _ from 'lodash';
import ConnectingLineSvg from './ConnectingLineSvg';


const HARBOR_OFFER_ICON_RADIUS = 10

function harborCenterX(harbor: Position) {
    return territoryCenterX(harbor)
}

function harborCenterY(harbor: Position) {
    return territoryCenterY(harbor)
}

const HARBOR_OFFER_ICON_BY_RESOURCE_ID = {
    [ResourceId.Brick]: BrickIcon,
    [ResourceId.Grain]: GrainIcon,
    [ResourceId.Lumber]: LumberIcon,
    [ResourceId.Ore]: OreIcon,
    [ResourceId.Wool]: WoolIcon,
}

function HarborOfferIcon({ harbor }: { harbor: Harbor }) {
    const resourceToGive = harbor.harborOffer.resourceToGive
    if (resourceToGive) {
        return <image
            x={harborCenterX(harbor) - HARBOR_OFFER_ICON_RADIUS}
            y={harborCenterY(harbor) - HARBOR_OFFER_ICON_RADIUS * 1.5}
            width={HARBOR_OFFER_ICON_RADIUS * 2}
            height={HARBOR_OFFER_ICON_RADIUS * 2}
            className={`harbor-offer-icon`}
            href={HARBOR_OFFER_ICON_BY_RESOURCE_ID[harbor.harborOffer.resourceToGive.id]}
        />
    }
    return <text
        x={harborCenterX(harbor)}
        y={harborCenterY(harbor) - HARBOR_OFFER_ICON_RADIUS * 1.5}
        fontSize="1.15em"
        fontWeight="bold"
        textAnchor="middle"
        dominantBaseline="text-before-edge"
    >?</text>
}

export default function({ harbor }: { harbor: Harbor }) {
    return (
        <React.Fragment>
            <HarborOfferIcon harbor={harbor} />
            <text
                x={harborCenterX(harbor)}
                y={harborCenterY(harbor) + HARBOR_OFFER_ICON_RADIUS * 0.25}
                textAnchor="middle"
                dominantBaseline="text-before-edge"
            >
                {harbor.harborOffer.exchangeRate} : 1
            </text>
            {
                _.map(harbor.corners, (corner, index) => (
                    <ConnectingLineSvg
                        key={index}
                        from={harbor}
                        to={corner}
                        fromMargin={20}
                        toMargin={10}
                        strokeWidth={1}
                    />
                ))
            }
        </React.Fragment>
    );
}
