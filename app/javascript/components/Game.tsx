import $ from 'jquery';
import React from 'react';
import CsrfTokenContext from '../models/CsrfTokenContext';
import { Game } from '../models/Game';
import { User } from '../models/User';
import BoardSvg from './BoardSvg';
import PlayerList from './PlayerList';


interface GameProps {
    game: Game
    user: User
}

export default function Game({ game, user }: GameProps) {
    const csrfToken = $('meta[name=csrf-token]').attr('content')
    return (
        <CsrfTokenContext.Provider value={csrfToken}>
            <div>
                <h1>Game</h1>
                <PlayerList players={game.players} user={user} />
                <BoardSvg territories={game.territories} />
            </div>
        </CsrfTokenContext.Provider>
    )
}
