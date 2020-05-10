import _ from 'lodash';
import React from 'react';
import Api from '../models/Api';
import { Game } from '../models/Game';
import { PlayerOffer, PlayerOfferAction } from '../models/PlayerOffer';
import NewPlayerOfferForm from './NewPlayerOfferForm';
import PlayerOfferResponseList from './PlayerOfferResponseList';
import { BrickIcon, GrainIcon, LumberIcon, OreIcon, WoolIcon } from './ResourceIcon';

interface PlayerOfferComponentProps {
    playerOffer: PlayerOffer
}

function AcceptPlayerOfferButton({ playerOffer: { playerOfferActions, id} }: PlayerOfferComponentProps) {
    if (!_.includes(playerOfferActions, PlayerOfferAction.CreatePlayerOfferAgreement)) {
        return null
    }

    const onClickAgree = () => {
        const asyncOnClickAgree = async () => {
            try {
                await Api.post(
                    `player_offers/${id}/player_offer_response.json`,
                    { playerOfferResponse: { agreeing: true } }
                )
            } catch (error) {
                console.log(error.response)
            }
        }

        asyncOnClickAgree()
    }

    return <button onClick={onClickAgree}>Agree to trade</button>
}

function RejectPlayerOfferButton({ playerOffer: { playerOfferActions, id } }: PlayerOfferComponentProps) {
    console.log(playerOfferActions[0])
    if (!_.includes(playerOfferActions, PlayerOfferAction.CreatePlayerOfferRejection)) {
        return null
    }

    const onClickAgree = () => {
        const asyncOnClickAgree = async () => {
            try {
                await Api.post(
                    `player_offers/${id}/player_offer_response.json`,
                    { playerOfferResponse: { agreeing: false } }
                )
            } catch (error) {
                console.log(error.response)
            }
        }

        asyncOnClickAgree()
    }

    return <button onClick={onClickAgree}>Reject trade</button>
}


function PlayerOffer({ playerOffer }: PlayerOfferComponentProps) {
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
            <div>
                <AcceptPlayerOfferButton playerOffer={playerOffer} />
                <RejectPlayerOfferButton playerOffer={playerOffer} />
            </div>
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
