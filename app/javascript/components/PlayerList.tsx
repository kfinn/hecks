import _ from 'lodash';
import pluralize from 'pluralize';
import React, { useState } from 'react';
import Api from '../models/Api';
import { Color } from '../models/Color';
import { Game } from '../models/Game';
import { Player, PlayerAction, playerActiveDevelopmentCardsCount, playerArmySize, playerColor, playerLongestRoadTraversalLength, playerName, playerScore, playerTotalResourceCardsCount } from '../models/Player';

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

    const stopEditing = (event: { preventDefault: () => void; }) => {
        event.preventDefault()
        setName(playerName(player))
        setColorId(playerColor(player))
        setEditing(false)
    }

    if (editing) {
        return <span>
            <form>
                <input type="text" className="form-control mb-1" onChange={({ target: { value } }) => setName(value)} value={name} />
                <select value={colorId} className="form-control mb-1" onChange={({ target: { value } }) => setColorId(value as Color)}>
                    {
                        _.map(Object.keys(Color), (colorName) => (
                            <option key={Color[colorName]} value={Color[colorName]}>{colorName}</option>
                        ))
                    }
                </select>
                <input type="submit" className="form-control mb-1 btn btn-light" value="Save" onClick={onSubmit} />
                <button className="form-control btn btn-light" onClick={stopEditing}>Cancel</button>
            </form>
        </span>
    } else {
        return <span>
            <ReadOnlyPlayerDescription player={player}/> (you)
            {' '}
            <button className="btn btn-link btn-sm text-muted" onClick={() => { setEditing(true) }}>Edit</button>
        </span>
    }
}

function ReadOnlyPlayerDescription({ player }: { player: Player }) {
    return (
        <React.Fragment>
            <span className="player-name">
                {playerName(player)}
            </span>
        </React.Fragment>
    )
}

const PLAYER_ACTIONS = {
    [PlayerAction.CreateRobbery]: async ({ id }: Player) => {
        return await Api.post(`players/${id}/robberies.json`)
    }
}

function PlayerDetailsEntry({ value, label, suffix }: { value: number, label: string, suffix?: string }) {
    return (
        <React.Fragment>
            <li className="list-group-item">
                {pluralize(label, value, true)} {suffix}
            </li>
        </React.Fragment>
    )
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
            <dl className="list-group list-group-flush">
                <PlayerDetailsEntry value={playerScore(player)} label="victory point" />
                <li className="list-group-item">longest road: {playerLongestRoadTraversalLength(player)}</li>
                <PlayerDetailsEntry value={playerArmySize(player)} label="knight" />
                <PlayerDetailsEntry value={playerActiveDevelopmentCardsCount(player)} label="dev card" />
                <PlayerDetailsEntry value={playerTotalResourceCardsCount(player)} label="card" />
                {
                    onClickRob ? (
                        <button className="list-group-item list-group-item-action list-group-item-danger" onClick={onClickRob}>
                            Rob this player
                        </button>
                    ) : null
                }
            </dl>
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
            <h4>Players</h4>
            <div className="row">
                {
                    _.map(players, (player) => {
                        return <div key={player.id} className="col-md col-sm-6 mb-3">
                            <div className={`card ${playerColor(player)}`}>
                                <div className="card-body">
                                    <div className="card-title">
                                    {
                                        player.user.isCurrentUser ? <CurrentUserPlayerDescription game={game} player={player} /> : <ReadOnlyPlayerDescription player={player} />
                                    }
                                    </div>
                                </div>
                                <PlayerDetails player={player} />
                            </div>
                        </div>
                    })
                }
            </div>
        </React.Fragment>
    )
}
