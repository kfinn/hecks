import _ from 'lodash';
import React, { useState } from 'react';
import Api from '../models/Api';
import { useCsrfToken } from '../models/CsrfTokenContext';
import { Player, playerName } from '../models/Player';
import { User } from '../models/User';

function CurrentUserPlayer({ player }: { player: Player }) {
    const [editing, setEditing] = useState(false)
    const [name, setName] = useState(playerName(player))
    const csrfToken = useCsrfToken()

    const onSubmit = (event) => {
        event.preventDefault()
        setEditing(false)

        const onSubmitAsync = async () => {
            const response = await Api({
                url: '/api/v1/current_user.json',
                method: 'put',
                data: {
                    currentUser: { name },
                    authenticityToken: csrfToken
                },
                responseType: 'json'
            })
            console.log(response.data)
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
    return <span>{playerName(player)}</span>
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
