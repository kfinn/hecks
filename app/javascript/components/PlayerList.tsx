import _ from 'lodash';
import React, { useState } from 'react';
import Api from '../models/Api';
import { Player, playerName, playerOrderingRollDescription } from '../models/Player';
import { User } from '../models/User';

function CurrentUserPlayer({ player }: { player: Player }) {
    const [editing, setEditing] = useState(false)
    const [name, setName] = useState(playerName(player))

    const onSubmit = (event: { preventDefault: () => void; }) => {
        event.preventDefault()
        setEditing(false)

        const onSubmitAsync = async () => {
            const response = await Api.put(
                'current_user.json',
                {
                    currentUser: { name }
                },
                { responseType: 'json' }
            )
        }

        onSubmitAsync()
    }

    if (editing) {
        return <span>
            <form>
                <input type="text" onChange={({ target: { value } }) => setName(value)} value={name} />
                <input type="submit" value="Save" onClick={onSubmit} />
            </form>
            <a href="#" onClick={(e) => { e.preventDefault(); setEditing(false) }}>Cancel</a>
        </span>
    } else {
        return <span>
            <ReadOnlyPlayer player={player} />
            <a href="#" onClick={(e) => { e.preventDefault(); setEditing(true) }}>Edit</a>
        </span>
    }
}

function ReadOnlyPlayer({ player }: { player: Player }) {
    return <span>
        {playerName(player)} {playerOrderingRollDescription(player)}
    </span>
}

export interface PlayerListProps {
    user: User
    players: Player[]
}

export default function PlayerList({ user, players }: PlayerListProps) {
    return (
        <React.Fragment>
            <h2>Players</h2>
            <ul>
                {
                    _.map(players, (player) => {
                        return <li key={player.id}>
                            {
                                player.user.id == user.id ? <CurrentUserPlayer player={player} /> : <ReadOnlyPlayer player={player} />
                            }
                        </li>
                    })
                }
            </ul>
        </React.Fragment>
    )
}
