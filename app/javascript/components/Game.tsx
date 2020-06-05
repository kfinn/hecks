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
import PendingDiscardRequirement from './PendingDiscardRequirement';
import PlayerOfferList from './PlayerOfferList';
import DevelopmentCardList from './DevelopmentCardList';
import { BrickIcon, GrainIcon, LumberIcon, OreIcon, WoolIcon } from './ResourceIcon';
import NotificationsPermissionsRequest from './NotificationsPermissionsRequest';

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

        return () => { console.log(subscription); subscription.disconnect() }
    }, [game.id])

    const onStartClicked = (event: { preventDefault: () => void }) => {
        event.preventDefault()

        const startAsync = async () => {
            try {
                await Api.post(`games/${game.id}/game_start.json`)
            } catch (error) {
                console.log(error.response)
            }
        }
        startAsync()
    }

    return (
        <div>
            <Status status={game.status} />
            <NotificationsPermissionsRequest />
            {gameIsStarted(game) ? null : <button className="btn btn-success" onClick={onStartClicked}>Start Game</button>}
            <div className="row">
                <div className="col-md-7 col-lg-7 col-xl-9 order-md-2">
                    <BoardSvg game={game} />
                </div>
                <div className="col-md-5 col-lg-5 col-xl-3 order-md-1">
                    {gameIsStarted(game) ? <div className="mb-3"><Dice game={game} /></div> : null}
                    <div className="mb-3"><PendingDiscardRequirement game={game} /></div>
                    <div className="mb-3"><Hand hand={game.hand} /></div>
                    <div className="mb-3"><DevelopmentCardList game={game} /></div>
                    <div className="mb-3"><PlayerOfferList game={game} /></div>
                    <div className="mb-3"><BankOfferList game={game} /></div>
                </div>
            </div>
            <PlayerList game={game} />
            <h4>Prices</h4>
            <ul>
                <li>
                    <h4>Road</h4>
                    <ul>
                        <li>
                            <BrickIcon /> &times; 1
                        </li>
                        <li>
                            <LumberIcon /> &times; 1
                        </li>
                    </ul>
                </li>
                <li>
                    <h4>Settlement</h4>
                    <ul>
                        <li>
                            <BrickIcon /> &times; 1
                        </li>
                        <li>
                            <GrainIcon /> &times; 1
                        </li>
                        <li>
                            <LumberIcon /> &times; 1
                        </li>
                        <li>
                            <WoolIcon /> &times; 1
                        </li>
                    </ul>
                </li>
                <li>
                    <h4>City</h4>
                    <ul>
                        <li>
                            <GrainIcon /> &times; 2
                        </li>
                        <li>
                            <OreIcon /> &times; 3
                        </li>
                    </ul>
                </li>
                <li>
                    <h4>Dev Card</h4>
                    <ul>
                        <li>
                            <GrainIcon /> &times; 1
                        </li>
                        <li>
                            <OreIcon /> &times; 1
                        </li>
                        <li>
                            <WoolIcon /> &times; 1
                        </li>
                    </ul>
                </li>
            </ul>
            <h4>Attribution</h4>
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
