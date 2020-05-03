import { createConsumer } from '@rails/actioncable';
import $ from 'jquery';
import React, { useState, useEffect } from 'react';
import Api from '../models/Api';
import CsrfTokenContext from '../models/CsrfTokenContext';
import { Game } from '../models/Game';
import { User } from '../models/User';
import BoardSvg from './BoardSvg';
import PlayerList from './PlayerList';

interface GameProps {
    game: Game
    user: User
}

const consumer = createConsumer()

export default function Game(props: GameProps) {
    const [game, setGame] = useState(props.game)
    const csrfToken = $('meta[name=csrf-token]').attr('content')

    const refresh = async () => {
        const response = await Api({
            url: `/api/v1/games/${game.id}.json`
        })
        setGame(response.data as Game)
    }

    useEffect(() => {
        const subscription = consumer.subscriptions.create(
            { channel: 'GamesChannel', id: game.id },
            {
                connected() {
                    refresh()
                },
                received() {
                    refresh()
                }
            }
        )

        return () => { subscription.disconnect() }
    }, [game.id])

    const onRefreshClicked = (event: { preventDefault: () => void; }) => {
        event.preventDefault()
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
