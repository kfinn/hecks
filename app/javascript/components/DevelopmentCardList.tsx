import React from 'react';
import { Game } from '../models/Game';
import _ from 'lodash';
import { NewDevelopmentCardAction, developmentCardDescription } from '../models/DevelopmentCard';
import Api from '../models/Api';
import DevelopmentCardForm from './DevelopmentCardForm';

const NEW_DEVELOPMENT_CARD_ACTIONS = {
    [NewDevelopmentCardAction.CreateDevelopmentCardPurchase]: async ({ id }: Game) => {
        return await Api.post(`games/${id}/development_card_purchases.json`)
    }
}

export default function DevelopmentCardList({ game }: { game: Game }) {
    const action = NEW_DEVELOPMENT_CARD_ACTIONS[game.newDevelopmentCardActions[0]]
    const onClick = () => {
        const asyncOnClick = async () => {
            try {
                await action(game)
            } catch (error) {
                console.log(error.response)
            }
        }
        asyncOnClick()
    }
    const disabled = !action

    return (
        <React.Fragment>
            <h4>Dev Cards</h4>
            <dl>
                {
                    game.developmentCards.length > 0 ? (
                        _.map(game.developmentCards, (developmentCard) => (
                            <React.Fragment key={developmentCard.id}>
                                <dt>{developmentCard.name}</dt>
                                <dd>
                                    <p>
                                        {developmentCardDescription(developmentCard)}
                                    </p>
                                    <div>
                                        <DevelopmentCardForm developmentCard={developmentCard} />
                                    </div>
                                </dd>
                            </React.Fragment>
                        ))
                    ) : 'None'
                }
            </dl>
            <button className="btn btn-secondary" onClick={onClick} disabled={disabled}>Purchase Dev Card</button>
        </React.Fragment>
    )
}
