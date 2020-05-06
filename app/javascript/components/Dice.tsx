import React from 'react';
import { DiceAction } from '../models/Dice';
import { Game } from '../models/Game';
import Api from '../models/Api';
import _ from 'lodash';

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

    let die1Value = '?'
    let die2Value = '?'
    if (latestRoll) {
        die1Value = latestRoll.die1Value.toString()
        die2Value = latestRoll.die2Value.toString()
    }

    return (
        <React.Fragment>
        <h2>Dice</h2>
        <p>({die1Value}, {die2Value})</p>
        {
            _.map(actions, ({ action, name, onClick }) => (
                <button key={action} onClick={() => { onClick(game) }}>{name}</button>
            ))
        }
        </React.Fragment>
    )
}
