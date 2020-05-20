import React, { useState } from 'react';
import useSafeNotification from './useSafeNotification';

export default function NotificationsPermissionsRequest() {
    const SafeNotification = useSafeNotification()
    if (!SafeNotification) {
        return null;
    }

    const [notificationPermission, setNotificationPermission] = useState(SafeNotification.permission)

    if (notificationPermission != 'granted') {
        const onClick = () => {
            const asyncOnClick = async () => {
                setNotificationPermission(await SafeNotification.requestPermission(setNotificationPermission))
            }
            asyncOnClick()
        }

        return (
            <div className="alert alert-warning">
                Notify me when there's something for me to do:
                {' '}
                <button className="btn btn-warning btn-sm" onClick={onClick}>
                    Enable Notifications
                </button>
            </div>
        )
    }
    return null;
}
