pragma Singleton
import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Controls

/**
 * The notification server component.
 * This is a singleton that lives for the lifetime of the shell,
 * and manages all notifications.
 */
Singleton {
    id: root

    // Expose the server so other components can check capabilities
    property alias trackedNotifications: server.trackedNotifications

    // Most recent notification for toasts
    property var latestNotification: null

    NotificationServer {
        id: server

        actionsSupported: true
        bodySupported: true
        imageSupported: true
        persistenceSupported: true

        onNotification: function(notif) {
            // Must explicitly track or it gets discarded
            notif.tracked = true
            root.latestNotification = notif
        }
    }
}