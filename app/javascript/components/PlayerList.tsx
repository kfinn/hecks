import _ from 'lodash';
import React, { useState } from 'react';
import Api from '../models/Api';
import { Game } from '../models/Game';
import { Player, playerColor, playerName, playerOrderingRollDescription, playerTotalResourceCardsCount, PlayerAction } from '../models/Player';
import { Color } from '../models/Color';

function CurrentUserPlayer({ game, player }: { game: Game, player: Player }) {
    const [editing, setEditing] = useState(false)
    const [name, setName] = useState(playerName(player))

    const onSubmitName = (event: { preventDefault: () => void; }) => {
        event.preventDefault()
        setEditing(false)

        const onSubmitNameAsync = async () => {
            return await Api.put(
                'current_user.json',
                { currentUser: { name } }
            )
        }

        onSubmitNameAsync()
    }

    const onColorChange = ({ target: { value }}) => {
        const submitColorAsync = async () => {
            return await Api.put(
                `games/${game.id}/current_player.json`,
                { currentPlayer: { colorId: value } }
            )
        }

        submitColorAsync()
    }

    if (editing) {
        return <span>
            <input type="text" onChange={({ target: { value } }) => setName(value)} value={name} />
            <select value={playerColor(player)} onChange={onColorChange}>
                {
                    _.map(Object.keys(Color), (colorName) => (
                        <option key={Color[colorName]} value={Color[colorName]}>{colorName}</option>
                    ))
                }
            </select>
            <input type="submit" value="Save" onClick={onSubmitName} />
            <a href="#" onClick={(e) => { e.preventDefault(); setEditing(false) }}>Cancel</a>
        </span>
    } else {
        return <span>
            <ReadOnlyPlayer player={player}/>
            <a href="#" onClick={(e) => { e.preventDefault(); setEditing(true) }}>Edit</a>
        </span>
    }
}

const PLAYER_ACTIONS = {
    [PlayerAction.CreateRobbery]: async ({ id }: Player) => {
        return await Api.post(`players/${id}/robberies.json`)
    }
}

function ReadOnlyPlayer({ player }: { player: Player }) {
    const action = PLAYER_ACTIONS[player.playerActions[0]]
    const onClickRob = action ? () => {
        const onClickRobAsync = async () => {
            try {
                await action(player)
            } catch(error) {
                console.log(error.response)
            }
        }

        onClickRobAsync()
    } : null

    return (
        <span>
            {playerName(player)}
            {' - '}
            {playerColor(player)}
            {' - '}
            {playerOrderingRollDescription(player)}
            {' - '}
            {playerTotalResourceCardsCount(player)} cards
            {
                onClickRob ? (
                    <button onClick={onClickRob}>Rob this player</button>
                ) : null
            }
        </span>
    )
}

export interface PlayerListProps {
    game: Game
}

export default function PlayerList({ game }: PlayerListProps) {
    const players = game.players
    return (
        <React.Fragment>
            <h2>Players</h2>
            <ul>
                {
                    _.map(players, (player) => {
                        return <li key={player.id}>
                            {
                                player.user.isCurrentUser ? <CurrentUserPlayer game={game} player={player} /> : <ReadOnlyPlayer player={player} />
                            }
                        </li>
                    })
                }
            </ul>
        </React.Fragment>
    )
}
