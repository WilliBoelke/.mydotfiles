import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.services

PanelWindow {
    id: root

    // Only show on the primary screen
    property bool isPrimary: screen === Quickshell.screens[1]

    anchors { bottom: true; right: true }
    implicitWidth: 360
    implicitHeight: toastCard.implicitHeight + 24
    color: "transparent"

    // Auto-dismiss timer
    Timer {
        id: dismissTimer
        interval: 5000
        onTriggered: root.visible = false
    }

    // Watch for new notifications
    Connections {
        target: NotificationService
        function onLatestNotificationChanged() {
            if (!root.isPrimary) return
            if (NotificationService.latestNotification === null) return
            root.visible = true
            dismissTimer.restart()
        }
    }

    visible: false

    NotificationCard {
        id: toastCard
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 12
        }
        notif: NotificationService.latestNotification
        backgroundColor: "#1aee1a1a"
        cardRadius: 8
        showActions: false
        showTime: false
        compact: true

        onDismissRequested: {
            dismissTimer.stop()
            root.visible = false
        }
    }
}