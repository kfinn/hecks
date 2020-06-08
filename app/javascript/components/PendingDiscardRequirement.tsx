import React, { useEffect, useState } from 'react';
import Api from '../models/Api';
import { DiscardRequirement } from '../models/DiscardRequirement';
import { Game } from '../models/Game';
import { ResourceId } from '../models/Resource';
import ResourceQuantityPicker from './ResourceQuantityPicker';
import useSafeNotification from './useSafeNotification';

export default function PendingDiscardRequirement({ game }: { game: Game }) {
    const SafeNotification = useSafeNotification()

    const hasPendingDiscardRequirement = !!game.pendingDiscardRequirement
    useEffect(() => {
        if (hasPendingDiscardRequirement && SafeNotification) {
            const notification = new SafeNotification(
                "Time to discard in Hecks",
                {
                    body: 'You had too many cards when someone rolled a seven.'
                }
            )
            return () => notification.close()
        }
        return () => { }
    },
        [hasPendingDiscardRequirement]
    )

    const discardRequirement = game.pendingDiscardRequirement as DiscardRequirement

    const [brickCardsCount, setBrickCardsCount] = useState(0)
    const [grainCardsCount, setGrainCardsCount] = useState(0)
    const [lumberCardsCount, setLumberCardsCount] = useState(0)
    const [oreCardsCount, setOreCardsCount] = useState(0)
    const [woolCardsCount, setWoolCardsCount] = useState(0)

    if (!hasPendingDiscardRequirement) {
        return null
    }

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
                setBrickCardsCount(0)
                setGrainCardsCount(0)
                setLumberCardsCount(0)
                setOreCardsCount(0)
                setWoolCardsCount(0)
            } catch (error) {
                console.log(error.response)
            }
        }

        onClickAsync()
    }

    return (
        <React.Fragment>
            <h4>Discard Requirement</h4>
            <p>You must discard {discardRequirement.resourceCardsCount} cards</p>
            <ul>
                <li>
                    <ResourceQuantityPicker
                        resourceId={ResourceId.Brick}
                        value={brickCardsCount}
                        max={game.hand.brickCardsCount}
                        onChange={setBrickCardsCount}
                    />
                </li>
                <li>
                    <ResourceQuantityPicker
                        resourceId={ResourceId.Grain}
                        value={grainCardsCount}
                        max={game.hand.grainCardsCount}
                        onChange={setGrainCardsCount}
                    />
                </li>
                <li>
                    <ResourceQuantityPicker
                        resourceId={ResourceId.Lumber}
                        value={lumberCardsCount}
                        max={game.hand.lumberCardsCount}
                        onChange={setLumberCardsCount}
                    />
                </li>
                <li>
                    <ResourceQuantityPicker
                        resourceId={ResourceId.Ore}
                        value={oreCardsCount}
                        max={game.hand.oreCardsCount}
                        onChange={setOreCardsCount}
                    />
                </li>
                <li>
                    <ResourceQuantityPicker
                        resourceId={ResourceId.Wool}
                        value={woolCardsCount}
                        max={game.hand.woolCardsCount}
                        onChange={setWoolCardsCount}
                    />
                </li>
            </ul>
            <button className="btn btn-danger" disabled={!valid} onClick={onClick}>Discard</button>
        </React.Fragment>
    )
}
