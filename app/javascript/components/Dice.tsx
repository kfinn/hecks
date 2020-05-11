import React from 'react';
import { DiceAction } from '../models/Dice';
import { Game } from '../models/Game';
import Api from '../models/Api';
import _ from 'lodash';

const DIE_FACES_BY_VALUE = {
    1: '⚀',
    2: '⚁',
    3: '⚂',
    4: '⚃',
    5: '⚄',
    6: '⚅'
}

const DICE_ACTIONS = {
    [DiceAction.CreateProductionRoll]: {
        action: DiceAction.CreateProductionRoll,
        name: 'Roll',
        onClick: async ({ id }: Game) => {
            return await Api.post(`games/${id}/production_rolls.json`)
        }
    },
    [DiceAction.EndTurn]: {
        action: DiceAction.EndTurn,
        name: 'End Turn',
        onClick: async({ id }: Game) => {
            return await Api.post(`games/${id}/repeating_turn_ends.json`)
        }
    }
}

export default function Dice({ game }: { game: Game }) {
    const { latestRoll, diceActions } = game.dice
    const actions = _.compact(_.map(diceActions, (action) => DICE_ACTIONS[action]))

    return (
        <React.Fragment>
            {
                latestRoll ? (
                    <div className="dice">{DIE_FACES_BY_VALUE[latestRoll.die1Value]}{DIE_FACES_BY_VALUE[latestRoll.die2Value]}</div>
                ) : null
            }
        {
            _.map(actions, ({ action, name, onClick }) => (
                <button className="btn btn-primary" key={action} onClick={() => { onClick(game) }}>{name}</button>
            ))
        }
        </React.Fragment>
    )
}
