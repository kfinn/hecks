import React from 'react';
import { DiceAction } from '../models/Dice';
import { Game, SpecialBuildPhaseAction, TurnAction } from '../models/Game';
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

const END_TURN_ACTION_PATHS = {
    [TurnAction.EndRepeatingTurn]: ({ id }) => `games/${id}/repeating_turn_ends.json`,
    [TurnAction.EndSpecialBuildPhaseTurn]: ({ id }) => `games/${id}/special_build_phase_turn_ends.json`
}

export default function Dice({ game }: { game: Game }) {
    const {
        id,
        allowsSpecialBuildPhase,
        dice: { latestRoll, diceActions },
        specialBuildPhaseActions,
        turnActions
     } = game

     const canRollDice = _.includes(diceActions, DiceAction.CreateProductionRoll.toString())
     const canCreateSpecialBuildPhase = _.includes(specialBuildPhaseActions, SpecialBuildPhaseAction.CreateSpecialBuildPhase.toString())
     const canEndTurn = _.some(_.keys(END_TURN_ACTION_PATHS), key => _.includes(turnActions, key))
    const endTurnPath = canEndTurn ? END_TURN_ACTION_PATHS[turnActions[0]](game) : null

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
                {
                    allowsSpecialBuildPhase && (
                        <button
                            className="btn btn-success"
                            onClick={() => { Api.post(`games/${id}/special_build_phases.json`) }}
                            disabled={!canCreateSpecialBuildPhase}
                        >
                            Build After This Turn
                        </button>
                    )
                }
                <button
                    className="btn btn-danger"
                    onClick={() => { Api.post(endTurnPath) }}
                    disabled={!canEndTurn}
                >
                    End Turn
                </button>
            </div>
        </React.Fragment>
    )
}
