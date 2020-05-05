import React from 'react';
import { DiceAction } from '../models/Dice';
import { Game } from '../models/Game';
import Api from '../models/Api';

const DICE_ACTIONS = {
    [DiceAction.CreateProductionRoll]: async ({ id }: Game) => {
        Api.post(`games/${id}/production_rolls.json`)
    }
}

export default function Dice({ game }: { game: Game }) {
    const { latestRoll, diceActions } = game.dice
    const action = DICE_ACTIONS[diceActions[0]]
    const onClick = action ? (() => {
        const asyncOnClick = async () => {
            try {
                await action(game)
            } catch(error) {
                console.log(error.response)
            }
        }
        asyncOnClick()
    }) : null

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
        <button onClick={onClick} disabled={!action}>Roll</button>
        </React.Fragment>
    )
}
