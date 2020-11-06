import { useWindowSize } from '@react-hook/window-size';
import React, { useEffect } from 'react';
import ReactConfetti from 'react-confetti';
import { Status, TurnStatus, WinnerStatus } from '../models/Status';
import useSafeNotification from './useSafeNotification';

function WinnerStatusNotification({ status }: { status: WinnerStatus }) {
    const {
        winner,
        winnerIsCurrentPlayer,
        winnerSettlementScore,
        winnerLargestArmyScore,
        winnerLongestRoadScore,
        winnerVictoryPointCardScore
    } = status

    const SafeNotification = useSafeNotification()
    useEffect(
        () => {
            if (SafeNotification) {
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

    const [width, height] = useWindowSize()

    return <React.Fragment>
        <h4>Status</h4>
        <p>
            {
                winnerIsCurrentPlayer ? 'You won! Congratulations!' : `${winner} won! Better luck next time.`
            }
        </p>
        <table>
        <tr>
            <td>Points from settlements:&nbsp;</td>
            <td>{winnerSettlementScore}</td>
        </tr>
        <tr>
            <td>Points from largest army:&nbsp;</td>
            <td>{winnerLargestArmyScore}</td>
        </tr>
        <tr>
            <td>Points from longest road:&nbsp;</td>
            <td>{winnerLongestRoadScore}</td>
        </tr>
        <tr>
            <td>Points from development cards:&nbsp;</td>
            <td>{winnerVictoryPointCardScore}</td>
        </tr>
        <tr>
            <td>Total points:&nbsp;</td>
                <td>{winnerSettlementScore + winnerLargestArmyScore + winnerLongestRoadScore + winnerVictoryPointCardScore}</td>
        </tr>
        </table>
        <ReactConfetti width={width} height={height} />
    </React.Fragment>
}

function TurnStatusNotification({ status: { actor, actorIsCurrentPlayer, description } }: { status: TurnStatus }) {
    const SafeNotification = useSafeNotification()
    useEffect(
        () => {
            if (actorIsCurrentPlayer && SafeNotification) {
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
