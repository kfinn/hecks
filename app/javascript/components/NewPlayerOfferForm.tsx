import React, { useState } from 'react';
import Api from "../models/Api";
import { Game } from "../models/Game";
import { NewPlayerOffer, NewPlayerOfferAction } from "../models/PlayerOffer";
import ResourceIcon, { BrickIcon, GrainIcon, LumberIcon, OreIcon, WoolIcon } from './ResourceIcon';
import _ from 'lodash';
import { ResourceId } from '../models/Resource';
import ResourceQuantityPicker from './ResourceQuantityPicker';

const NEW_PLAYER_OFFER_ACTIONS = {
    [NewPlayerOfferAction.CreatePlayerOffer]: async (game: Game, playerOffer: NewPlayerOffer) => {
        return await Api.post(
            `games/${game.id}/player_offers.json`,
            { playerOffer }
        )
    }
}

export default function NewPlayerOfferForm({ game }: { game: Game }) {
    const [editing, setEditing] = useState(false)
    const [brickCardsCountFromOfferingPlayer, setBrickCardsCountFromOfferingPlayer] = useState(0)
    const [grainCardsCountFromOfferingPlayer, setGrainCardsCountFromOfferingPlayer] = useState(0)
    const [lumberCardsCountFromOfferingPlayer, setLumberCardsCountFromOfferingPlayer] = useState(0)
    const [oreCardsCountFromOfferingPlayer, setOreCardsCountFromOfferingPlayer] = useState(0)
    const [woolCardsCountFromOfferingPlayer, setWoolCardsCountFromOfferingPlayer] = useState(0)
    const [brickCardsCountFromAgreeingPlayer, setBrickCardsCountFromAgreeingPlayer] = useState(0)
    const [grainCardsCountFromAgreeingPlayer, setGrainCardsCountFromAgreeingPlayer] = useState(0)
    const [lumberCardsCountFromAgreeingPlayer, setLumberCardsCountFromAgreeingPlayer] = useState(0)
    const [oreCardsCountFromAgreeingPlayer, setOreCardsCountFromAgreeingPlayer] = useState(0)
    const [woolCardsCountFromAgreeingPlayer, setWoolCardsCountFromAgreeingPlayer] = useState(0)

    const action = NEW_PLAYER_OFFER_ACTIONS[game.newPlayerOfferActions[0]]
    if (!action) {
        return null;
    }

    const onClick = action ? (() => {
        const onClickAsync = async () => {
            try {
                await action(
                    game,
                    {
                        brickCardsCountFromOfferingPlayer,
                        grainCardsCountFromOfferingPlayer,
                        lumberCardsCountFromOfferingPlayer,
                        oreCardsCountFromOfferingPlayer,
                        woolCardsCountFromOfferingPlayer,
                        brickCardsCountFromAgreeingPlayer,
                        grainCardsCountFromAgreeingPlayer,
                        lumberCardsCountFromAgreeingPlayer,
                        oreCardsCountFromAgreeingPlayer,
                        woolCardsCountFromAgreeingPlayer
                    }
                )
                setBrickCardsCountFromOfferingPlayer(0)
                setGrainCardsCountFromOfferingPlayer(0)
                setLumberCardsCountFromOfferingPlayer(0)
                setOreCardsCountFromOfferingPlayer(0)
                setWoolCardsCountFromOfferingPlayer(0)
                setBrickCardsCountFromAgreeingPlayer(0)
                setGrainCardsCountFromAgreeingPlayer(0)
                setLumberCardsCountFromAgreeingPlayer(0)
                setOreCardsCountFromAgreeingPlayer(0)
                setWoolCardsCountFromAgreeingPlayer(0)
                setEditing(false)
            } catch (error) {
                console.log(error.response)
            }
        }

        onClickAsync()
    }) : null

    const valid = (
        (
            brickCardsCountFromOfferingPlayer +
            grainCardsCountFromOfferingPlayer +
            lumberCardsCountFromOfferingPlayer +
            oreCardsCountFromOfferingPlayer +
            woolCardsCountFromOfferingPlayer > 0
        ) && (
            brickCardsCountFromAgreeingPlayer +
            grainCardsCountFromAgreeingPlayer +
            lumberCardsCountFromAgreeingPlayer +
            oreCardsCountFromAgreeingPlayer +
            woolCardsCountFromAgreeingPlayer > 0
        )
    )

    return (
        <React.Fragment>
            {
                editing ? (
                    <React.Fragment>
                        <div>
                            I want to give...
                            <ul>
                                <li>
                                    <ResourceQuantityPicker
                                        resourceId={ResourceId.Brick}
                                        value={brickCardsCountFromOfferingPlayer}
                                        onChange={setBrickCardsCountFromOfferingPlayer}
                                        max={game.hand.brickCardsCount}
                                    />
                                </li>
                                <li>
                                    <ResourceQuantityPicker
                                        resourceId={ResourceId.Grain}
                                        value={grainCardsCountFromOfferingPlayer}
                                        onChange={setGrainCardsCountFromOfferingPlayer}
                                        max={game.hand.grainCardsCount}
                                    />
                                </li>
                                <li>
                                    <ResourceQuantityPicker
                                        resourceId={ResourceId.Lumber}
                                        value={lumberCardsCountFromOfferingPlayer}
                                        onChange={setLumberCardsCountFromOfferingPlayer}
                                        max={game.hand.lumberCardsCount}
                                    />
                                </li>
                                <li>
                                    <ResourceQuantityPicker
                                        resourceId={ResourceId.Ore}
                                        value={oreCardsCountFromOfferingPlayer}
                                        onChange={setOreCardsCountFromOfferingPlayer}
                                        max={game.hand.oreCardsCount}
                                    />
                                </li>
                                <li>
                                    <ResourceQuantityPicker
                                        resourceId={ResourceId.Wool}
                                        value={woolCardsCountFromOfferingPlayer}
                                        onChange={setWoolCardsCountFromOfferingPlayer}
                                        max={game.hand.woolCardsCount}
                                    />
                                </li>
                            </ul>
                        </div>
                        <div>
                            I want to receive...
                            <ul>
                                <li>
                                    <ResourceQuantityPicker
                                        resourceId={ResourceId.Brick}
                                        value={brickCardsCountFromAgreeingPlayer}
                                        onChange={setBrickCardsCountFromAgreeingPlayer}
                                        max={4}
                                    />
                                </li>
                                <li>
                                    <ResourceQuantityPicker
                                        resourceId={ResourceId.Grain}
                                        value={grainCardsCountFromAgreeingPlayer}
                                        onChange={setGrainCardsCountFromAgreeingPlayer}
                                        max={4}
                                    />
                                </li>
                                <li>
                                    <ResourceQuantityPicker
                                        resourceId={ResourceId.Lumber}
                                        value={lumberCardsCountFromAgreeingPlayer}
                                        onChange={setLumberCardsCountFromAgreeingPlayer}
                                        max={4}
                                    />
                                </li>
                                <li>
                                    <ResourceQuantityPicker
                                        resourceId={ResourceId.Ore}
                                        value={oreCardsCountFromAgreeingPlayer}
                                        onChange={setOreCardsCountFromAgreeingPlayer}
                                        max={4}
                                    />
                                </li>
                                <li>
                                    <ResourceQuantityPicker
                                        resourceId={ResourceId.Wool}
                                        value={woolCardsCountFromAgreeingPlayer}
                                        onChange={setWoolCardsCountFromAgreeingPlayer}
                                        max={4}
                                    />
                                </li>
                            </ul>
                        </div>
                        <div className="btn-group" role="group">
                            <button className="btn btn-primary" onClick={onClick} disabled={!valid}>Create Player Offer</button>
                            <button className="btn btn-secondary" onClick={() => setEditing(false)}>Cancel</button>
                        </div>
                    </React.Fragment>
                ) : (
                        <button className="btn btn-secondary" onClick={() => setEditing(true)}>New Player Offer</button>
                    )
            }
        </React.Fragment>
    )
}
