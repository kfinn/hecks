import _ from 'lodash';
import React from 'react';
import Api from '../models/Api';
import { PlayerOffer } from '../models/PlayerOffer';
import { PlayerOfferResponse, PlayerOfferResponseAction } from '../models/PlayerOfferResponse';

const PLAYER_OFFER_AGREEMENT_ACTIONS = {
    [PlayerOfferResponseAction.CreatePlayerTrade]: async ({ id }: PlayerOfferResponse) => {
        return await Api.post(`player_offer_responses/${id}/player_trade.json`)
    }
}

function PlayerOfferResponse({ playerOfferResponse }: { playerOfferResponse: PlayerOfferResponse }) {
    const action = PLAYER_OFFER_AGREEMENT_ACTIONS[playerOfferResponse.playerOfferResponseActions[0]]
    const onClick = action ? (() => {
        const asyncOnClick = async () => {
            try {
                await action(playerOfferResponse)
            } catch (error) {
                console.log(error.response)
            }
        }

        asyncOnClick()
    }): null

    return (
        <React.Fragment>
            {playerOfferResponse.playerName}
            {' '}
            {playerOfferResponse.agreeing ? 'agreed to' : 'rejected'}
            {' the offer '}
            {
                action ? (<button className="btn btn-primary" onClick={onClick}>Trade with {playerOfferResponse.playerName}</button>) : null
            }
        </React.Fragment>
    )
}

export default function PlayerOfferResponseList({ playerOffer }: { playerOffer: PlayerOffer }) {
    return (
        <React.Fragment>
            <h5>Responses:</h5>
            {
                playerOffer.playerOfferResponses.length > 0 ? (
                    _.map(playerOffer.playerOfferResponses, (playerOfferResponse) => (
                        <div key={playerOfferResponse.id}>
                            <PlayerOfferResponse playerOfferResponse={playerOfferResponse} />
                        </div>
                    ))
                ) : (<div>None</div>)
            }
        </React.Fragment>
    )
}
