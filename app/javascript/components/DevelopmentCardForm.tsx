import React, { useState } from 'react';
import { DevelopmentCardAction, DevelopmentCard } from '../models/DevelopmentCard';
import Api from '../models/Api';
import _ from 'lodash';
import { ResourceId } from '../models/Resource';
import ResourceIdPicker from './ResourceIdPicker';

interface FormProps {
    developmentCard: DevelopmentCard
}

function KnightCardPlayForm({ developmentCard: { id } }: FormProps) {
    const onClick = () => {
        const onClickAsync = async () => {
            try {
                await Api.post(`development_cards/${id}/knight_card_play.json`)
            } catch (error) {
                console.log(error.response)
            }
        }
        onClickAsync()
    }

    return (
        <div className="inline-form">
            <button className="btn btn-secondary form-control" onClick={onClick}>Play Knight</button>
        </div>
    )
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
                console.log(error.response)
            }
        }
        onClickAsync()
    }

    return (
        <div className="inline-form">
            <ResourceIdPicker
                id="monopoly-card-play-resource-id-picker"
                value={resourceId}
                onChange={setResourceId}
                className="form-control mb-1"
            />
            <button className="btn btn-secondary form-control" onClick={onClick}>Play Monopoly</button>
        </div>
    )
}

function YearOfPlentyCardPlayForm({ developmentCard: { id } }: FormProps) {
    const [resource1Id, setResource1Id] = useState(_.values(ResourceId)[0])
    const [resource2Id, setResource2Id] = useState(_.values(ResourceId)[0])
    const onClick = () => {
        const onClickAsync = async () => {
            try {
                await Api.post(
                    `development_cards/${id}/year_of_plenty_card_play.json`,
                    { yearOfPlentyCardPlay: { resource_1Id: resource1Id, resource_2Id: resource2Id } }
                )
            } catch (error) {
                console.log(error.response)
            }
        }
        onClickAsync()
    }

    return (
        <div className="inline-form">
            <ResourceIdPicker
                id="year-of-plenty-card-play-resource-1-id-picker"
                value={resource1Id}
                onChange={setResource1Id}
                className="form-control mb-1"
            />
            {' '}
            <ResourceIdPicker
                id="year-of-plenty-card-play-resource-2-id-picker"
                value={resource2Id}
                onChange={setResource2Id}
                className="form-control mb-1"
            />
            {' '}
            <button className="btn btn-secondary form-control" onClick={onClick}>Play Year of Plenty</button>
        </div>
    )
}

function RoadBuildingCardPlayForm({ developmentCard: { id } }: FormProps) {
    const onClick = () => {
        const onClickAsync = async () => {
            try {
                await Api.post(`development_cards/${id}/road_building_card_play.json`)
            } catch (error) {
                console.log(error.response)
            }
        }
        onClickAsync()
    }

    return (
        <div className="inline-form">
            <button className="btn btn-secondary form-control" onClick={onClick}>Play Road Building</button>
        </div>
    )
}

const FORMS_BY_DEVELOPMENT_CARD_ACTION = {
    [DevelopmentCardAction.CreateKnightCardPlay]: KnightCardPlayForm,
    [DevelopmentCardAction.CreateMonopolyCardPlay]: MonopolyCardPlayForm,
    [DevelopmentCardAction.CreateRoadBuildingCardPlay]: RoadBuildingCardPlayForm,
    [DevelopmentCardAction.CreateYearOfPlentyCardPlay]: YearOfPlentyCardPlayForm
}

export default function DevelopmentCardForm({ developmentCard }: { developmentCard: DevelopmentCard }) {
    const Form = FORMS_BY_DEVELOPMENT_CARD_ACTION[developmentCard.developmentCardActions[0]]
    return Form ? <Form developmentCard={developmentCard} /> : null
}
