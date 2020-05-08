import _ from 'lodash';
import React from 'react';
import Api from '../models/Api';
import { PlayerOffer } from '../models/PlayerOffer';
import { PlayerOfferAgreement, PlayerOfferAgreementAction } from '../models/PlayerOfferAgreement';

const PLAYER_OFFER_AGREEMENT_ACTIONS = {
    [PlayerOfferAgreementAction.CreatePlayerTrade]: async ({ id }: PlayerOfferAgreement) => {
        return await Api.post(`player_offer_agreements/${id}/player_trade.json`)
    }
}

function PlayerOfferAgreement({ playerOfferAgreement }: { playerOfferAgreement: PlayerOfferAgreement }) {
    const action = PLAYER_OFFER_AGREEMENT_ACTIONS[playerOfferAgreement.playerOfferAgreementActions[0]]
    const onClick = action ? (() => {
        const asyncOnClick = async () => {
            try {
                await action(playerOfferAgreement)
            } catch (error) {
                console.log(error.response)
            }
        }

        asyncOnClick()
    }): null

    return (
        <React.Fragment>
            {playerOfferAgreement.playerName}
            {' '}
            {
                action ? (<button onClick={onClick}>Trade with {playerOfferAgreement.playerName}</button>) : null
            }
        </React.Fragment>
    )
}

export default function PlayerOfferAgreementList({ playerOffer }: { playerOffer: PlayerOffer }) {
    return (
        <React.Fragment>
            <h3>Agreed to by...</h3>
            {
                playerOffer.playerOfferAgreements.length > 0 ? (
                    <ul>
                        {
                            _.map(playerOffer.playerOfferAgreements, (playerOfferAgreement) => (
                                <li key={playerOfferAgreement.id}>
                                    <PlayerOfferAgreement playerOfferAgreement={playerOfferAgreement} />
                                </li>
                            ))
                        }
                    </ul>
                ) : 'No one'
            }
        </React.Fragment>
    )
}
