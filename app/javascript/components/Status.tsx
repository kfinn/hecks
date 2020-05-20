import React, { useEffect } from 'react';
import { Status, TurnStatus, WinnerStatus } from '../models/Status';
import useSafeNotification from './useSafeNotification';

function WinnerStatusNotification({ status: { winner, winnerIsCurrentPlayer} }: { status: WinnerStatus }) {
    const SafeNotification = useSafeNotification()
    useEffect(
        () => {
            if (document.hidden && SafeNotification) {
                const title = `${winnerIsCurrentPlayer ? 'You' : winner} won in Hecks`
                const body = winnerIsCurrentPlayer ? 'Congratulations!' : "Better luck next time."
                const notification = new SafeNotification(
                    title,
                    { body }
                )
                return () => notification.close()
            }
            return () => { }
        },
        [winnerIsCurrentPlayer]
    )

    return <React.Fragment>
        <h4>Status</h4>
        <p>{winnerIsCurrentPlayer ? 'You' : winner} won!</p>
    </React.Fragment>
}

function TurnStatusNotification({ status: { actor, actorIsCurrentPlayer, description } }: { status: TurnStatus }) {
    const SafeNotification = useSafeNotification()
    useEffect(
        () => {
            if (actorIsCurrentPlayer && document.hidden && SafeNotification) {
                const notification = new SafeNotification(
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

export default function Status({ status }: { status: Status }) {
    const turnStatus = status as TurnStatus
    if (turnStatus.actor) {
        return <TurnStatusNotification status={turnStatus} />
    }

    const winnerStatus = status as WinnerStatus
    if (winnerStatus.winner) {
        return <WinnerStatusNotification status={winnerStatus} />
    }
    return null
}
