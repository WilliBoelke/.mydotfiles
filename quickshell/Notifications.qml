import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.services
import qs.decoratives

Item {
    id: root

    implicitHeight: container.implicitHeight
    implicitWidth: container.implicitWidth

    Card {
        id: container

        property int outerPadding: 12

        implicitHeight: contentCol.implicitHeight + (outerPadding * 2)
        width: parent.width

        ColumnLayout {
            id: contentCol

            anchors.margins: 12
            spacing: 12

            anchors {
                fill: parent
                margins: outerPadding
            }
            RowLayout {
                width: parent.width

                Text {
                    color: "#d55c1b"
                    font.pixelSize: 20
                    font.weight: Font.Bold
                    text: "Notifications"
                    topPadding: 4
                }
                Item {
                    Layout.fillWidth: true
                }
                Text {
                    color: "#d55c1b"
                    font.pixelSize: 11
                    text: "Clear all"
                    visible: NotificationService.trackedNotifications.values.length > 0

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            var notifs = NotificationService.trackedNotifications.values;
                            for (var i = notifs.length - 1; i >= 0; i--) {
                                notifs[i].tracked = false;
                            }
                        }
                    }
                }
            }
            Item {
                Layout.fillWidth: true
                implicitHeight: notifList.visible ? notifList.implicitHeight : fallback.implicitHeight

                ListView {
                    id: notifList

                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    clip: true
                    implicitHeight: contentHeight
                    model: NotificationService.trackedNotifications
                    spacing: 8
                    visible: NotificationService.trackedNotifications.values.length > 0

                    delegate: NotificationCard {
                        required property var modelData

                        compact: false
                        height: implicitHeight
                        notif: modelData
                        showActions: true
                        showTime: true
                        width: ListView.view.width

                        onDismissRequested: notif.tracked = false
                    }
                }
                Text {
                    id: fallback

                    anchors.centerIn: parent
                    color: "#d55c1b"
                    font.pixelSize: 14
                    text: "No notifications"
                    visible: !notifList.visible
                }
            }
        }
    }
}
