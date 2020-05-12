import React, { useEffect } from 'react';
import { Status } from '../models/Status';

export default function Status({ status }: { status: Status }) {
    const { actor, actorIsCurrentPlayer, description } = status
    useEffect(
        () => {
            if (actorIsCurrentPlayer && document.hidden) {
                const notification = new Notification(
                    "Your turn in Hecks",
                    {
                        body: `It's your turn to ${description}`
                    }
                )
                return () => notification.close()
            }
            return () => { }
        },
        [actorIsCurrentPlayer]
    )

    return <React.Fragment>
        <h4>Status</h4>
        <p>Waiting for {actor} to {description}</p>
    </React.Fragment>
}
