import React from 'react';
import { Game } from '../models/Game';
import { PlayerOffer, PlayerOfferAction, NewPlayerOfferAction, NewPlayerOffer } from '../models/PlayerOffer';
import Api from '../models/Api';
import { BrickIcon, GrainIcon, LumberIcon, OreIcon, WoolIcon } from './ResourceIcon';
import _ from 'lodash';
import NewPlayerOfferForm from './NewPlayerOfferForm';
import PlayerOfferAgreementList from './PlayerOfferAgreementList';

const PLAYER_OFFER_ACTIONS = {
    [PlayerOfferAction.CreatePlayerOfferAgreement]: async ({ id }: PlayerOffer) => {
        return await Api.post(`player_offers/${id}/player_offer_agreement.json`)
    }
}

function PlayerOffer({ playerOffer }: { playerOffer: PlayerOffer }) {
    const action = PLAYER_OFFER_ACTIONS[playerOffer.playerOfferActions[0]]
    const onClick = action ? (() => {
        const asyncOnClick = async () => {
            try {
                await action(playerOffer)
            } catch (error) {
                console.log(error.response)
            }
        }

        asyncOnClick()
    }) : null

    return (
        <React.Fragment>
            <div>
                <h3>{playerOffer.playerName} offers to give...</h3>
                <ul>
                    {
                        playerOffer.brickCardsCountFromOfferingPlayer > 0 ? (
                            <li>
                                <BrickIcon /> &times; {playerOffer.brickCardsCountFromOfferingPlayer}
                            </li>
                        ) : null
                    }
                    {
                        playerOffer.grainCardsCountFromOfferingPlayer > 0 ? (
                            <li>
                                <GrainIcon /> &times; {playerOffer.grainCardsCountFromOfferingPlayer}
                            </li>
                        ) : null
                    }
                    {
                        playerOffer.lumberCardsCountFromOfferingPlayer > 0 ? (
                            <li>
                                <LumberIcon /> &times; {playerOffer.lumberCardsCountFromOfferingPlayer}
                            </li>
                        ) : null
                    }
                    {
                        playerOffer.oreCardsCountFromOfferingPlayer > 0 ? (
                            <li>
                                <OreIcon /> &times; {playerOffer.oreCardsCountFromOfferingPlayer}
                            </li>
                        ) : null
                    }
                    {
                        playerOffer.woolCardsCountFromOfferingPlayer > 0 ? (
                            <li>
                                <WoolIcon /> &times; {playerOffer.woolCardsCountFromOfferingPlayer}
                            </li>
                        ) : null
                    }
                </ul>
            </div>
            <div>
                <h3>{playerOffer.playerName} wants to receive...</h3>
                <ul>
                    {
                        playerOffer.brickCardsCountFromAgreeingPlayer > 0 ? (
                            <li>
                                <BrickIcon /> &times; {playerOffer.brickCardsCountFromAgreeingPlayer}
                            </li>
                        ) : null
                    }
                    {
                        playerOffer.grainCardsCountFromAgreeingPlayer > 0 ? (
                            <li>
                                <GrainIcon /> &times; {playerOffer.grainCardsCountFromAgreeingPlayer}
                            </li>
                        ) : null
                    }
                    {
                        playerOffer.lumberCardsCountFromAgreeingPlayer > 0 ? (
                            <li>
                                <LumberIcon /> &times; {playerOffer.lumberCardsCountFromAgreeingPlayer}
                            </li>
                        ) : null
                    }
                    {
                        playerOffer.oreCardsCountFromAgreeingPlayer > 0 ? (
                            <li>
                                <OreIcon /> &times; {playerOffer.oreCardsCountFromAgreeingPlayer}
                            </li>
                        ) : null
                    }
                    {
                        playerOffer.woolCardsCountFromAgreeingPlayer > 0 ? (
                            <li>
                                <WoolIcon /> &times; {playerOffer.woolCardsCountFromAgreeingPlayer}
                            </li>
                        ) : null
                    }
                </ul>
            </div>
            <div>
                <PlayerOfferAgreementList playerOffer={playerOffer} />
            </div>
            {
                action ? (<div><button onClick={onClick}>Agree to trade</button></div>) : null
            }
        </React.Fragment>
    )
}

export default function PlayerOfferList({ game }: { game: Game }) {
    return (
        <React.Fragment>
            <h2>Player Offers</h2>
            <ul>
                {
                    _.map(game.playerOffers, (playerOffer) => (
                        <li key={playerOffer.id}>
                            <PlayerOffer playerOffer={playerOffer} />
                        </li>
                    ))
                }
            </ul>
            {
                <NewPlayerOfferForm game={game} />
            }
        </React.Fragment>
    )
}
