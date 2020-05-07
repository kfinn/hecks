import { createConsumer } from '@rails/actioncable';
import _ from 'lodash';
import React, { useEffect, useState } from 'react';
import Api from '../models/Api';
import { Game, gameIsStarted } from '../models/Game';
import BoardSvg from './BoardSvg';
import PlayerList from './PlayerList';
import Hand from './Hand';
import Dice from './Dice';
import Status from './Status';
import BankOfferList from './BankOfferList';

interface GameProps {
    game: Game
}

const consumer = createConsumer()

export default function Game(props: GameProps) {
    const [game, setGame] = useState(props.game)

    const refresh = async () => {
        const response = await Api.get(`/games/${game.id}.json`)
        setGame(response.data as Game)
    }

    const debouncedRefresh = _.debounce(refresh)

    useEffect(() => {
        const subscription = consumer.subscriptions.create(
            { channel: 'GamesChannel', id: game.id },
            {
                connected() {
                    debouncedRefresh()
                },
                received() {
                    debouncedRefresh()
                }
            }
        )

        return () => { subscription.disconnect() }
    }, [game.id])

    const onRefreshClicked = (event: { preventDefault: () => void }) => {
        event.preventDefault()
        refresh()
    }

    const onStartClicked = (event: { preventDefault: () => void }) => {
        event.preventDefault()

        const startAsync = async () => {
            try {
                await Api.post(`games/${game.id}/game_start`)
            } catch (error) {
                console.log(error.response)
            }
        }
        startAsync()
    }

    return (
        <div>
            <h1>Game</h1>
            <a href="#" onClick={onRefreshClicked}>Refresh</a>
            {gameIsStarted(game) ? null : <button onClick={onStartClicked}>Start Game</button>}
            <Status status={game.status} />
            <PlayerList game={game} />
            <Dice game={game} />
            <BoardSvg game={game} />
            <Hand hand={game.hand} />
            <BankOfferList game={game} />
            <h2>Attribution</h2>
            <ul>
                <li>Brick icon: Created by Ben Davis from the Noun Project</li>
                <li>Grain icon: Created by Adrien Coquet from the Noun Project</li>
                <li>Lumber icon: Created by Luthfi Ahmad Robbaniy from the Noun Project</li>
                <li>Ore icon: Created by Franco Mateo from the Noun Project</li>
                <li>Wool icon: Created by Unrecognized MJ from the Noun Project</li>
            </ul>
        </div>
    )
}
