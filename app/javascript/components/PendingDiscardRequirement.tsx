import React, { useState } from 'react';
import { Game } from '../models/Game';
import { DiscardRequirement } from '../models/DiscardRequirement';
import { BrickIcon, GrainIcon, LumberIcon, OreIcon, WoolIcon } from './ResourceIcon';
import _ from 'lodash';
import Api from '../models/Api';

export default function PendingDiscardRequirement({ game }: { game: Game }) {
    if (!game.pendingDiscardRequirement) {
        return null
    }

    const discardRequirement = game.pendingDiscardRequirement as DiscardRequirement

    const [brickCardsCount, setBrickCardsCount] = useState(0)
    const [grainCardsCount, setGrainCardsCount] = useState(0)
    const [lumberCardsCount, setLumberCardsCount] = useState(0)
    const [oreCardsCount, setOreCardsCount] = useState(0)
    const [woolCardsCount, setWoolCardsCount] = useState(0)

    const totalCardsCount =
        brickCardsCount +
        grainCardsCount +
        lumberCardsCount +
        oreCardsCount +
        woolCardsCount

    const valid = totalCardsCount == discardRequirement.resourceCardsCount

    const onClick = () => {
        const onClickAsync = async () => {
            try {
                await Api.post(
                    `discard_requirements/${discardRequirement.id}/discard.json`,
                    {
                        discard: {
                            brickCardsCount,
                            grainCardsCount,
                            lumberCardsCount,
                            oreCardsCount,
                            woolCardsCount
                        }
                    }
                )
            } catch (error) {
                console.log(error.response)
            }
        }

        onClickAsync()
    }

    return (
        <React.Fragment>
            <h2>Discard Requirement</h2>
            <p>You must discard {discardRequirement.resourceCardsCount} cards</p>
            <ul>
                <li>
                    <BrickIcon />
                    {
                        game.hand.brickCardsCount > 0 ? (
                            <select value={brickCardsCount} onChange={({ target: { value } }) => setBrickCardsCount(parseInt(value))}>
                                {
                                    _.map(_.range(game.hand.brickCardsCount), (count) => (
                                        <option key={count} value={count}>{count}</option>
                                    ))
                                }
                            </select>
                        ) : '---'
                    }
                </li>
                <li>
                    <GrainIcon />
                    {
                        game.hand.grainCardsCount > 0 ? (
                                <select value={grainCardsCount} onChange={({ target: { value } }) => setGrainCardsCount(parseInt(value))}>
                                    {
                                        _.map(_.range(game.hand.grainCardsCount), (count) => (
                                            <option key={count} value={count}>{count}</option>
                                        ))
                                    }
                                </select>
                        ) : ' --- '
                    }
                </li>
                <li>
                    <LumberIcon />
                        {
                            game.hand.lumberCardsCount > 0 ? (
                                <select value={lumberCardsCount} onChange={({ target: { value } }) => setLumberCardsCount(parseInt(value))}>
                                    {
                                        _.map(_.range(game.hand.lumberCardsCount), (count) => (
                                            <option key={count} value={count}>{count}</option>
                                        ))
                                    }
                                </select>
                            ) : '---'
                        }
                </li>
                <li>
                    <OreIcon />
                        {
                            game.hand.oreCardsCount > 0 ? (
                                <select value={oreCardsCount} onChange={({ target: { value } }) => setOreCardsCount(parseInt(value))}>
                                    {
                                        _.map(_.range(game.hand.oreCardsCount), (count) => (
                                            <option key={count} value={count}>{count}</option>
                                        ))
                                    }
                                </select>
                            ) : '---'
                        }
                </li>
                <li>
                    <WoolIcon />
                        {
                            game.hand.woolCardsCount > 0 ? (
                                <select value={woolCardsCount} onChange={({ target: { value } }) => setWoolCardsCount(parseInt(value))}>
                                    {
                                        _.map(_.range(game.hand.woolCardsCount), (count) => (
                                            <option key={count} value={count}>{count}</option>
                                        ))
                                    }
                                </select>
                            ) : '---'
                        }
                </li>
            </ul>
            <button disabled={!valid} onClick={onClick}>Discard</button>
        </React.Fragment>
    )
}
