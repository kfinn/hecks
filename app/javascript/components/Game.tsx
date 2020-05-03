import $ from 'jquery';
import React, { useState } from 'react';
import CsrfTokenContext from '../models/CsrfTokenContext';
import { Game } from '../models/Game';
import { User } from '../models/User';
import BoardSvg from './BoardSvg';
import PlayerList from './PlayerList';
import Api from '../models/Api';


interface GameProps {
    game: Game
    user: User
}

export default function Game(props: GameProps) {
    const [game, setGame] = useState(props.game)
    const csrfToken = $('meta[name=csrf-token]').attr('content')

    const onRefreshClicked = (event) => {
        event.preventDefault()
        const refresh = async () => {
            const response = await Api({
                url: `/api/v1/games/${game.id}.json`
            })
            setGame(response.data as Game)
        }

        refresh()
    }

    return (
        <CsrfTokenContext.Provider value={csrfToken}>
            <div>
                <h1>Game</h1>
                <a href="#" onClick={onRefreshClicked}>Refresh</a>
                <PlayerList players={game.players} user={props.user} />
                <BoardSvg territories={game.territories} />
            </div>
        </CsrfTokenContext.Provider>
    )
}
