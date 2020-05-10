import React from 'react';
import { Game } from '../models/Game';
import { PlayerOffer, PlayerOfferAction, NewPlayerOfferAction, NewPlayerOffer } from '../models/PlayerOffer';
import Api from '../models/Api';
import { BrickIcon, GrainIcon, LumberIcon, OreIcon, WoolIcon } from './ResourceIcon';
import _ from 'lodash';
import NewPlayerOfferForm from './NewPlayerOfferForm';
import PlayerOfferResponseList from './PlayerOfferResponseList';

const PLAYER_OFFER_ACTIONS = {
    [PlayerOfferAction.CreatePlayerOfferResponse]: async ({ id }: PlayerOffer, agreeing: boolean) => {
        return await Api.post(
            `player_offers/${id}/player_offer_response.json`,
            { playerOfferResponse: { agreeing } }
        )
    }
}

function PlayerOffer({ playerOffer }: { playerOffer: PlayerOffer }) {
    const action = PLAYER_OFFER_ACTIONS[playerOffer.playerOfferActions[0]]
    const onClickAgree = action ? (() => {
        const asyncOnClickAgree = async () => {
            try {
                await action(playerOffer, true)
            } catch (error) {
                console.log(error.response)
            }
        }

        asyncOnClickAgree()
    }) : null
    const onClickReject = action ? (() => {
        const asyncOnClickReject = async () => {
            try {
                await action(playerOffer, false)
            } catch (error) {
                console.log(error.response)
            }
        }

        asyncOnClickReject()
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
                <PlayerOfferResponseList playerOffer={playerOffer} />
            </div>
            {
                action ? (
                <div>
                    <button onClick={onClickAgree}>Agree to trade</button>
                    <button onClick={onClickReject}>Reject trade</button>
                </div>
            ) : null
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
