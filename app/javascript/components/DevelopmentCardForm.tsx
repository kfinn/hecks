import React, { useState } from 'react';
import { DevelopmentCardAction, DevelopmentCard } from '../models/DevelopmentCard';
import Api from '../models/Api';
import _ from 'lodash';
import { ResourceId } from '../models/Resource';
import ResourceIdPicker from './ResourceIdPicker';

interface FormProps {
    developmentCard: DevelopmentCard
}

function MonopolyCardPlayForm({ developmentCard: { id } }: FormProps) {
    const [resourceId, setResourceId] = useState(_.values(ResourceId)[0])
    const onClick = () => {
        const onClickAsync = async () => {
            try {
                await Api.post(
                    `development_cards/${id}/monopoly_card_play.json`,
                    { monopolyCardPlay: { resourceId } }
                )
            } catch (error) {
                console.log(error)
            }
        }
        onClickAsync()
    }

    return (
        <React.Fragment>
            {': '}
            <ResourceIdPicker
                value={resourceId}
                onChange={setResourceId}
            />
            {' '}
            <button onClick={onClick}>Play Monopoly</button>
        </React.Fragment>
    )
}

function KnightCardPlayForm({ developmentCard: { id } }: FormProps) {
    const onClick = () => {
        const onClickAsync = async () => {
            try {
                await Api.post(`development_cards/${id}/knight_card_play.json`)
            } catch (error) {
                console.log(error)
            }
        }
        onClickAsync()
    }

    return (
        <React.Fragment>
            {': '}
            <button onClick={onClick}>Play Knight</button>
        </React.Fragment>
    )
}

const FORMS_BY_DEVELOPMENT_CARD_ACTION = {
    [DevelopmentCardAction.CreateMonopolyCardPlay]: MonopolyCardPlayForm,
    [DevelopmentCardAction.CreateKnightCardPlay]: KnightCardPlayForm
}

export default function DevelopmentCardForm({ developmentCard }: { developmentCard: DevelopmentCard }) {
    const Form = FORMS_BY_DEVELOPMENT_CARD_ACTION[developmentCard.developmentCardActions[0]]
    return Form ? <Form developmentCard={developmentCard} /> : null
}
