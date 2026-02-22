import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

PanelWindow {
    id: root

    // Only show on the primary screen
    property bool isPrimary: screen === Quickshell.screens[0]

    anchors { bottom: true; right: true }
    implicitWidth: 360
    implicitHeight: toastContent.implicitHeight + 24
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

    Rectangle {
        id: toastContent
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 12
        }
        implicitHeight: row.implicitHeight + 20
        radius: 8
        color: "#ee1a1a1a"

        RowLayout {
            id: row
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 12
            }
            spacing: 10

            // App icon
            IconImage {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                Layout.maximumWidth: 32
                Layout.maximumHeight: 32
                Layout.alignment: Qt.AlignTop
                source: Quickshell.iconPath(
                    NotificationService.latestNotification?.appIcon ?? "", ""
                )
                visible: source !== ""
            }

            // Title + body
            Column {
                Layout.fillWidth: true
                spacing: 3

                Text {
                    width: parent.width
                    text: NotificationService.latestNotification?.summary ?? ""
                    color: "#ffffff"
                    font.pixelSize: 13
                    font.weight: Font.Medium
                    elide: Text.ElideRight
                    textFormat: Text.PlainText
                }

                Text {
                    width: parent.width
                    text: NotificationService.latestNotification?.body ?? ""
                    color: "#aaaaaa"
                    font.pixelSize: 11
                    elide: Text.ElideRight
                    wrapMode: Text.WordWrap
                    maximumLineCount: 3
                    textFormat: Text.PlainText
                    visible: text !== ""
                }
            }

            // Dismiss button
            Text {
                text: "✕"
                color: "#666"
                font.pixelSize: 12
                Layout.alignment: Qt.AlignTop

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        dismissTimer.stop()
                        root.visible = false
                    }
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }
}