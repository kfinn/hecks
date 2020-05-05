import React from 'react';
import { Hand } from '../models/Hand';

export default function Hand({ hand }: { hand: Hand }) {
    return (
        <React.Fragment>
            <h2>Hand</h2>
            <ul>
                <li><img className="hand-icon" src={require('../images/brick.svg')} /> {hand.brickCardsCount}</li>
                <li><img className="hand-icon" src={require('../images/grain.svg')} /> {hand.grainCardsCount}</li>
                <li><img className="hand-icon" src={require('../images/lumber.svg')} /> {hand.lumberCardsCount}</li>
                <li><img className="hand-icon" src={require('../images/ore.svg')} /> {hand.oreCardsCount}</li>
                <li><img className="hand-icon" src={require('../images/wool.svg')} /> {hand.woolCardsCount}</li>
            </ul>
        </React.Fragment>
    )
}
