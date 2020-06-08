import _ from 'lodash';
import React, { useEffect } from 'react';
import Api from '../models/Api';
import { Game } from '../models/Game';
import { PlayerOffer, PlayerOfferAction } from '../models/PlayerOffer';
import NewPlayerOfferForm from './NewPlayerOfferForm';
import PlayerOfferResponseList from './PlayerOfferResponseList';
import { BrickIcon, GrainIcon, LumberIcon, OreIcon, WoolIcon } from './ResourceIcon';
import useSafeNotification from './useSafeNotification';

interface PlayerOfferComponentProps {
    playerOffer: PlayerOffer
}

function AcceptPlayerOfferButton({ playerOffer: { playerOfferActions, id } }: PlayerOfferComponentProps) {
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

    return <button className="btn btn-primary" onClick={onClickAgree}>Accept</button>
}

function RejectPlayerOfferButton({ playerOffer: { playerOfferActions, id } }: PlayerOfferComponentProps) {
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

    return <button className="btn btn-danger" onClick={onClickAgree}>Reject</button>
}


function PlayerOffer({ playerOffer }: PlayerOfferComponentProps) {
    return (
        <React.Fragment>
            <div>
                <h5>{playerOffer.playerName} offers to give:</h5>
                {
                    playerOffer.brickCardsCountFromOfferingPlayer > 0 ? (
                        <div>
                            <BrickIcon /> &times; {playerOffer.brickCardsCountFromOfferingPlayer}
                        </div>
                    ) : null
                }
                {
                    playerOffer.grainCardsCountFromOfferingPlayer > 0 ? (
                        <div>
                            <GrainIcon /> &times; {playerOffer.grainCardsCountFromOfferingPlayer}
                        </div>
                    ) : null
                }
                {
                    playerOffer.lumberCardsCountFromOfferingPlayer > 0 ? (
                        <div>
                            <LumberIcon /> &times; {playerOffer.lumberCardsCountFromOfferingPlayer}
                        </div>
                    ) : null
                }
                {
                    playerOffer.oreCardsCountFromOfferingPlayer > 0 ? (
                        <div>
                            <OreIcon /> &times; {playerOffer.oreCardsCountFromOfferingPlayer}
                        </div>
                    ) : null
                }
                {
                    playerOffer.woolCardsCountFromOfferingPlayer > 0 ? (
                        <div>
                            <WoolIcon /> &times; {playerOffer.woolCardsCountFromOfferingPlayer}
                        </div>
                    ) : null
                }
            </div>
            <div>
                <h5>{playerOffer.playerName} wants to receive:</h5>
                {
                    playerOffer.brickCardsCountFromAgreeingPlayer > 0 ? (
                        <div>
                            <BrickIcon /> &times; {playerOffer.brickCardsCountFromAgreeingPlayer}
                        </div>
                    ) : null
                }
                {
                    playerOffer.grainCardsCountFromAgreeingPlayer > 0 ? (
                        <div>
                            <GrainIcon /> &times; {playerOffer.grainCardsCountFromAgreeingPlayer}
                        </div>
                    ) : null
                }
                {
                    playerOffer.lumberCardsCountFromAgreeingPlayer > 0 ? (
                        <div>
                            <LumberIcon /> &times; {playerOffer.lumberCardsCountFromAgreeingPlayer}
                        </div>
                    ) : null
                }
                {
                    playerOffer.oreCardsCountFromAgreeingPlayer > 0 ? (
                        <div>
                            <OreIcon /> &times; {playerOffer.oreCardsCountFromAgreeingPlayer}
                        </div>
                    ) : null
                }
                {
                    playerOffer.woolCardsCountFromAgreeingPlayer > 0 ? (
                        <div>
                            <WoolIcon /> &times; {playerOffer.woolCardsCountFromAgreeingPlayer}
                        </div>
                    ) : null
                }
            </div>
            <div>
                <PlayerOfferResponseList playerOffer={playerOffer} />
            </div>
            <div className="btn-group" role="group">
                <AcceptPlayerOfferButton playerOffer={playerOffer} />
                <RejectPlayerOfferButton playerOffer={playerOffer} />
            </div>
        </React.Fragment>
    )
}

export default function PlayerOfferList({ game }: { game: Game }) {
    const anyPlayerOfferActions = _.some(game.playerOffers, ({ playerOfferActions }) => playerOfferActions.length > 0)

    const SafeNotification = useSafeNotification()

    useEffect(
        () => {
            if (anyPlayerOfferActions && SafeNotification) {
                const notification = new SafeNotification(
                    "New trade offer in Hecks",
                    {
                        body: `You have a new offer to review`
                    }
                )
                return () => notification.close()
            }
            return () => { }
        },
        [anyPlayerOfferActions]
    )

    const playerOfferResponses = _.flatMap(game.playerOffers, ({ playerOfferResponses }) => playerOfferResponses)
    const anyPlayerOfferResponses = _.some(playerOfferResponses, ({ playerOfferResponseActions }) => playerOfferResponseActions.length > 0)

    useEffect(
        () => {
            if (anyPlayerOfferResponses && SafeNotification) {
                const notification = new SafeNotification(
                    "New trade offer response in Hecks",
                    {
                        body: `Someone has accepted your offer`
                    }
                )
                return () => notification.close()
            }
            return () => { }
        },
        [anyPlayerOfferResponses]
    )

    if (game.playerOffers.length == 0 && game.newPlayerOfferActions.length == 0) {
        return null;
    }

    return (
        <React.Fragment>
            <h4>Player Offers</h4>
            <ul>
                {
                    _.map(game.playerOffers, (playerOffer) => (
                        <li key={playerOffer.id} className="mb-4">
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
