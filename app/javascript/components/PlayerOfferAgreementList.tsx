import React from 'react';
import { PlayerOffer } from '../models/PlayerOffer';
import _ from 'lodash';

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
                                    {playerOfferAgreement.playerName}
                                    {/* {' '}
                                    {
                                        action ? (<button onClick={onClick}>Trade with {playerOfferAgreement.playerName}</button>) : null
                                    } */}
                                </li>
                            ))
                        }
                    </ul>
                ) : 'No one'
            }
        </React.Fragment>
    )
}
