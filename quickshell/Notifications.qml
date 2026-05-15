import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.services
import qs.decoratives
import qs.texts

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

            implicitHeight: 48

            anchors {
                fill: parent
                margins: outerPadding
            }

            // -- header ---
            RowLayout {
                height: 48
                Layout.alignment: Qt.AlignVCenter
                width: parent.width
                TextH1 {
                    height: parent.height
                    Layout.alignment: Qt.AlignVCenter
                    text: "Notifications"
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

            // --- items ---
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
            }
        }
    }
}
