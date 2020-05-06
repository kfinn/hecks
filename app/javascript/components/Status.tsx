import React from 'react';
import { Status } from '../models/Status';

export default function Status({ status: { actor, description} }: { status: Status }) {
    return <React.Fragment>
        <h2>Status</h2>
        <p>Waiting for {actor} to {description}</p>
    </React.Fragment>
}
