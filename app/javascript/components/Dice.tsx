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
        name: 'Roll Dice',
        buttonVariant: 'primary',
        onClick: async ({ id }: Game) => {
            return await Api.post(`games/${id}/production_rolls.json`)
        }
    },
    [DiceAction.EndRepeatingTurn]: {
        name: 'End Turn',
        buttonVariant: 'danger',
        onClick: async({ id }: Game) => {
            return await Api.post(`games/${id}/repeating_turn_ends.json`)
        }
    },
    [DiceAction.EndSpecialBuildPhaseTurn]: {
        name: 'End Turn',
        buttonVariant: 'danger',
        onClick: async ({ id }: Game) => {
            return await Api.post(`games/${id}/special_build_phase_turn_ends.json`)
        }
    }
}

export default function Dice({ game }: { game: Game }) {
    const { latestRoll, diceActions } = game.dice
    const canRollDice = _.includes(diceActions, DiceAction.CreateProductionRoll.toString())

    return (
        <React.Fragment>
            {
                latestRoll ? (
                    <div className="dice">{DIE_FACES_BY_VALUE[latestRoll.die1Value]}{DIE_FACES_BY_VALUE[latestRoll.die2Value]}</div>
                ) : (
                    <div className="dice">{DIE_FACES_BY_VALUE[1]}{DIE_FACES_BY_VALUE[1]}</div>
                )
            }
            <div className="btn-group" role="group">
                <button
                    className="btn btn-primary"
                    onClick={() => { Api.post(`games/${id}/production_rolls.json`) }}
                    disabled={!canRollDice}
                >
                    Roll Dice
                </button>
                <button
                    className="btn btn-danger"
                    onClick={() => { DICE_ACTIONS[]}}
                {
                    _.map(_.values(DICE_ACTIONS), ({ action, name, buttonVariant, onClick }) => (
                        <button
                            className={`btn btn-${buttonVariant}`}
                            key={action}
                            onClick={() => { onClick(game) }}
                            disabled={!_.includes(diceActions, action)}
                        >
                            {name}
                        </button>
                    ))
                }
            </div>
        </React.Fragment>
    )
}
