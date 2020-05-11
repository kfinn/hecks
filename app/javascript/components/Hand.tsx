import React from 'react';
import { Hand } from '../models/Hand';
import { BrickIcon, GrainIcon, LumberIcon, OreIcon, WoolIcon } from './ResourceIcon';

export default function Hand({ hand }: { hand: Hand }) {
    return (
        <React.Fragment>
            <h4>Hand</h4>
            <BrickIcon />&nbsp;&times;&nbsp;{hand.brickCardsCount}<br />
            <GrainIcon />&nbsp;&times;&nbsp;{hand.grainCardsCount}<br />
            <LumberIcon />&nbsp;&times;&nbsp;{hand.lumberCardsCount}<br />
            <OreIcon />&nbsp;&times;&nbsp;{hand.oreCardsCount}<br />
            <WoolIcon />&nbsp;&times;&nbsp;{hand.woolCardsCount}<br />
        </React.Fragment>
    )
}
