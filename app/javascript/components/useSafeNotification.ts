export default function useSafeNotification() {
    try {
        return Notification
    } catch {
        return undefined
    }
}
