import React, { useState } from 'react';

export default function NotificationsPermissionsRequest() {
    const [notificationPermission, setNotificationPermission] = useState(Notification.permission)

    if (notificationPermission != 'granted') {
        const onClick = () => {
            const asyncOnClick = async () => {
                try {
                    setNotificationPermission(await Notification.requestPermission())
                } catch {
                    Notification.requestPermission(setNotificationPermission)
                }
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
