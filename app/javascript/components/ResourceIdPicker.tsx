import React from 'react';
import { ResourceId, resourceIdName } from '../models/Resource';
import _ from 'lodash';
import { Dropdown, DropdownButton } from 'react-bootstrap';
import ResourceIcon from './ResourceIcon';

export interface ResourceIdPickerProps {
    id: string
    value: ResourceId
    onChange: (value: ResourceId) => void
    disabled?: boolean
    options?: ResourceId[]
    className?: string
}

export default function ResourceIdPicker({ id, value, onChange, disabled, options, className }: ResourceIdPickerProps) {
    return (
        disabled ? (
            <DropdownButton
                id={id}
                title={<ResourceIcon resourceId={value} />}
                disabled
                className={className || "d-inline-block"}
                variant="outline-secondary"
                size="sm"
            />
        ) : (
            <Dropdown className={className ? '' : "d-inline-block"}>
                <Dropdown.Toggle id={id} variant="outline-secondary" size="sm" className={className}>
                    <ResourceIcon resourceId={value} />
                </Dropdown.Toggle>

                <Dropdown.Menu>
                    {
                        _.map((options || _.values(ResourceId)), (resourceId) => (
                            <Dropdown.Item key={resourceId} onClick={() => onChange(resourceId)} active={value == resourceId}>
                                <ResourceIcon resourceId={resourceId} />
                            </Dropdown.Item>
                        ))
                    }
                </Dropdown.Menu>
            </Dropdown>
        )
    )
}
