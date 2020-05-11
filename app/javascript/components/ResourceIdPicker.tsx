import React from 'react';
import { ResourceId, resourceIdName } from '../models/Resource';
import _ from 'lodash';

export interface ResourceIdPickerProps {
    value: ResourceId
    onChange: (value: ResourceId) => void
    disabled?: boolean
    options?: ResourceId[]
    className?: string
}

export default function ResourceIdPicker({ value, onChange, disabled, options, className }: ResourceIdPickerProps) {
    return (
        <select
            className={className || "form-control"}
            value={value}
            disabled={disabled || false}
            onChange={({ target: { value } }) => onChange(value as ResourceId)}
        >
            {
                _.map((options || _.values(ResourceId)), (resourceId) => (
                    <option key={resourceId} value={resourceId}>{resourceIdName(resourceId)}</option>
                ))
            }
        </select>
    )
}
