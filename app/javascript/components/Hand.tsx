import React from 'react';
import { Hand } from '../models/Hand';
import { BrickIcon, GrainIcon, LumberIcon, OreIcon, WoolIcon } from './ResourceIcon';

export default function Hand({ hand }: { hand: Hand }) {
    return (
        <React.Fragment>
            <h2>Hand</h2>
            <ul>
                <li><BrickIcon /> {hand.brickCardsCount}</li>
                <li><GrainIcon /> {hand.grainCardsCount}</li>
                <li><LumberIcon /> {hand.lumberCardsCount}</li>
                <li><OreIcon /> {hand.oreCardsCount}</li>
                <li><WoolIcon /> {hand.woolCardsCount}</li>
            </ul>
        </React.Fragment>
    )
}
