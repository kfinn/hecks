import React from 'react'
import { ResourceId } from '../models/Resource'
import ResourceIcon from './ResourceIcon'
import _ from 'lodash'

interface ResourceQuantityPickerProps {
    value: number
    onChange: (value: number) => void
    max: number
    resourceId: ResourceId
}

export default function ResourceQuantityPicker({ value, onChange, max, resourceId }: ResourceQuantityPickerProps) {
    return (
        <React.Fragment>
            <ResourceIcon resourceId={resourceId} />
            {' '}&times;{' '}
            {
                max > 0 ? (
                    <select value={value} onChange={({ target: { value } }) => onChange(parseInt(value))}>
                        {
                            _.map(_.range(max + 1), (i) => (
                                <option key={i} value={i}>{i}</option>
                            ))
                        }
                    </select>
                ) : '---'
            }
        </React.Fragment>
    )
}
