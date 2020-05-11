import React, { useState } from 'react';
import { Game } from '../models/Game';
import { DiscardRequirement } from '../models/DiscardRequirement';
import { BrickIcon, GrainIcon, LumberIcon, OreIcon, WoolIcon } from './ResourceIcon';
import _ from 'lodash';
import Api from '../models/Api';
import ResourceQuantityPicker from './ResourceQuantityPicker';
import { ResourceId } from '../models/Resource';

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
            <button disabled={!valid} onClick={onClick}>Discard</button>
        </React.Fragment>
    )
}
