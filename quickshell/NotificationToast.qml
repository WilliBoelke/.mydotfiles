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

    color: "transparent"
    implicitHeight: toastCard.implicitHeight + 24
    implicitWidth: 360
    visible: false

    anchors {
        bottom: true
        right: true
    }

    // Auto-dismiss timer
    Timer {
        id: dismissTimer

        interval: 5000

        onTriggered: root.visible = false
    }

    // Watch for new notifications
    Connections {
        function onLatestNotificationChanged() {
            if (!root.isPrimary)
                return;
            if (NotificationService.latestNotification === null)
                return;
            root.visible = true;
            dismissTimer.restart();
        }

        target: NotificationService
    }
    NotificationCard {
        id: toastCard

        compact: true
        notif: NotificationService.latestNotification
        showActions: false
        showTime: false

        onDismissRequested: {
            dismissTimer.stop();
            root.visible = false;
        }

        anchors {
            bottom: parent.bottom
            left: parent.left
            margins: 12
            right: parent.right
        }
    }
}