import React from 'react';
import BrickIcon from '../images/brick.svg';
import GrainIcon from '../images/grain.svg';
import LumberIcon from '../images/lumber.svg';
import OreIcon from '../images/ore.svg';
import WoolIcon from '../images/wool.svg';
import { Hand } from '../models/Hand';

export default function Hand({ hand }: { hand: Hand }) {
    return (
        <React.Fragment>
            <h2>Hand</h2>
            <ul>
                <li><img className="hand-icon" src={BrickIcon} /> {hand.brickCardsCount}</li>
                <li><img className="hand-icon" src={GrainIcon} /> {hand.grainCardsCount}</li>
                <li><img className="hand-icon" src={LumberIcon} /> {hand.lumberCardsCount}</li>
                <li><img className="hand-icon" src={OreIcon} /> {hand.oreCardsCount}</li>
                <li><img className="hand-icon" src={WoolIcon} /> {hand.woolCardsCount}</li>
            </ul>
        </React.Fragment>
    )
}
