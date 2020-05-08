import React, { useState } from 'react';
import { BankOffer, BankOfferAction } from '../models/BankOffer';
import { Game } from '../models/Game';
import _ from 'lodash';
import ResourceIcon from './ResourceIcon';
import { ResourceId, resourceIdName } from '../models/Resource';
import Api from '../models/Api';
import ResourceIdPicker from './ResourceIdPicker';

const BANK_OFFER_ACTIONS = {
    [BankOfferAction.CreateBankTrade]: async (game: Game, bankOffer: BankOffer, resourceToReceiveId: ResourceId) => {
        return await Api.post(
            `games/${game.id}/bank_offers/${bankOffer.resourceToGive.id}/bank_trades.json`,
            { bankTrade: { resourceToReceiveId } }
        )
    }
}

function BankOffer({ game, bankOffer }: { game: Game, bankOffer: BankOffer }) {
    const resourceIdOptions = _.difference(_.values(ResourceId), [bankOffer.resourceToGive.id])
    const [resourceToReceiveId, setResourceToReceiveId] = useState(resourceIdOptions[0])

    const action = BANK_OFFER_ACTIONS[bankOffer.bankOfferActions[0]]
    const disabled = !action
    const onClick = action ? () => { action(game, bankOffer, resourceToReceiveId) } : null

    return (
        <React.Fragment>
            <ResourceIcon resourceId={bankOffer.resourceToGive.id} />
            {' '}&times;{' '}
            { bankOffer.resourceToGiveCountRequired }
            {' '}&rarr;{' '}
            <ResourceIdPicker
                value={resourceToReceiveId}
                onChange={setResourceToReceiveId}
                disabled={disabled}
                options={resourceIdOptions}
            />
            {' '}&times; 1{' '}
            <button onClick={onClick} disabled={disabled}>Trade</button>
        </React.Fragment>
    )
}

export default function BankOfferList({ game }: { game: Game }) {
    return (
        <React.Fragment>
            <h2>Bank Offers</h2>
            <ul>
                {
                    _.map(game.bankOffers, (bankOffer) => (
                        <li key={bankOffer.resourceToGive.id}>
                            <BankOffer game={game} bankOffer={bankOffer} />
                        </li>
                    ))
                }
            </ul>
        </React.Fragment>
    )
}
