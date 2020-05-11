import React from 'react';
import { Status } from '../models/Status';

export default function Status({ status: { actor, description} }: { status: Status }) {
    return <React.Fragment>
        <h4>Status</h4>
        <p>Waiting for {actor} to {description}</p>
    </React.Fragment>
}
