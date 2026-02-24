import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.services

Item {
    id: root

    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight


    Rectangle {
        id: container
        color: "#1a000000"
        radius: 12
        width: parent.width
        property int outerPadding: 12
        implicitHeight: contentCol.implicitHeight + (outerPadding * 2)

        ColumnLayout {
            id: contentCol
            implicitHeight: childrenRect.height
            anchors {
                fill: parent
                margins: outerPadding
            }
            spacing: 12
            RowLayout {
                width: parent.width

                Text {
                    text: "Notifications"
                    color: "#d55c1b"
                    font.pixelSize: 24
                    font.weight: Font.Bold
                    topPadding: 4
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "Clear all"
                    color: "#666"
                    font.pixelSize: 11
                    visible: NotificationService.trackedNotifications.values.length > 0

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var notifs = NotificationService.trackedNotifications.values
                            for (var i = notifs.length - 1; i >= 0; i--) {
                                notifs[i].tracked = false
                            }
                        }
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }

            ListView {
                Layout.fillWidth: true
                implicitHeight: contentHeight
                Layout.preferredHeight: implicitHeight
                clip: true
                spacing: 8

                model: NotificationService.trackedNotifications

                delegate: NotificationCard {
                    required property var modelData
                    notif: modelData

                    width: ListView.view.width
                    height: implicitHeight
                    cardRadius: 6
                    showActions: true
                    showTime: true
                    compact: false

                    onDismissRequested: notif.tracked = false
                }
            }
        }
    }
}
