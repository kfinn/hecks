import _ from 'lodash';
import React, { useState } from 'react';
import Api from '../models/Api';
import { Game } from '../models/Game';
import { Player, playerColor, playerName, playerOrderingRollDescription, playerTotalResourceCardsCount, PlayerAction, playerActiveDevelopmentCardsCount, playerArmySize, playerScore, playerLongestRoadTraversalLength } from '../models/Player';
import { Color } from '../models/Color';
import pluralize from 'pluralize';

function CurrentUserPlayerDescription({ game, player }: { game: Game, player: Player }) {
    const [editing, setEditing] = useState(false)
    const [name, setName] = useState(playerName(player))
    const [colorId, setColorId] = useState(playerColor(player))

    const onSubmit = (event: { preventDefault: () => void; }) => {
        event.preventDefault()
        setEditing(false)

        const onSubmitAsync = async () => {
            return await Api.put(
                `games/${game.id}/current_player.json`,
                { currentPlayer: { name: name, colorId: colorId } }
            )
        }

        onSubmitAsync()
    }

    const stopEditing = () => {
        setName(playerName(player))
        setColorId(playerColor(player))
        setEditing(false)
    }

    if (editing) {
        return <span>
            <input type="text" onChange={({ target: { value } }) => setName(value)} value={name} />
            <select value={playerColor(player)} onChange={({ target: { value } }) => setColorId(value as Color)}>
                {
                    _.map(Object.keys(Color), (colorName) => (
                        <option key={Color[colorName]} value={Color[colorName]}>{colorName}</option>
                    ))
                }
            </select>
            <input type="submit" value="Save" onClick={onSubmit} />
            {' '}
            <a href="#" onClick={(e) => { e.preventDefault(); stopEditing() }}>Cancel</a>
        </span>
    } else {
        return <span>
            <ReadOnlyPlayerDescription player={player}/>
            {' '}
            <a href="#" onClick={(e) => { e.preventDefault(); setEditing(true) }}>Edit</a>
        </span>
    }
}

function ReadOnlyPlayerDescription({ player }: { player: Player }) {
    return (
        <React.Fragment>
            {playerName(player)}
            {' - '}
            {playerColor(player)}
            {' - '}
            {playerOrderingRollDescription(player)}
        </React.Fragment>
    )
}

const PLAYER_ACTIONS = {
    [PlayerAction.CreateRobbery]: async ({ id }: Player) => {
        return await Api.post(`players/${id}/robberies.json`)
    }
}

function PlayerDetailsEntry({ value, label, suffix }: { value: number, label: string, suffix?: string }) {
    return <li>
        {pluralize(label, value, true)} {suffix}
    </li>
}

function PlayerDetails({ player }: { player: Player }) {
    const action = PLAYER_ACTIONS[player.playerActions[0]]
    const onClickRob = action ? () => {
        const onClickRobAsync = async () => {
            try {
                await action(player)
            } catch (error) {
                console.log(error.response)
            }
        }

        onClickRobAsync()
    } : null

    return (
        <React.Fragment>
            <ul>
                <PlayerDetailsEntry value={playerTotalResourceCardsCount(player)} label="resource card" />
                <PlayerDetailsEntry value={playerActiveDevelopmentCardsCount(player)} label="development card" />
                <PlayerDetailsEntry value={playerArmySize(player)} label="knight" />
                <PlayerDetailsEntry value={playerLongestRoadTraversalLength(player)} label="segment" suffix="in longest road" />
                <PlayerDetailsEntry value={playerScore(player)} label="victory point" />
                {
                    onClickRob ? (
                        <li><button onClick={onClickRob}>Rob this player</button></li>
                    ) : null
                }
            </ul>
        </React.Fragment>
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
                                player.user.isCurrentUser ? <CurrentUserPlayerDescription game={game} player={player} /> : <ReadOnlyPlayerDescription player={player} />
                            }
                            <PlayerDetails player={player} />
                        </li>
                    })
                }
            </ul>
        </React.Fragment>
    )
}
