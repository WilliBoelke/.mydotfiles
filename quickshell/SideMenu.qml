import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

PanelWindow {
    id: root

    // Just this binding directly
    property bool open: NotificationService.sideMenuOpen &&
        NotificationService.sideMenuScreen === screen.name
    property int panelWidth: 600

    margins {
        top: 20
        bottom: 20
        right: 20
    }




    anchors {
        top: true;
        bottom: true;
        right: true
    }

    width: root.panelWidth
    color: "transparent"
    exclusionMode: ExclusionMode.Normal

    // main penal boxa
    Rectangle {
        radius : 12
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            rightMargin: root.open ? 0 : -root.panelWidth
        }

        width: root.panelWidth
        color: "#1a000000"

        Behavior on anchors.rightMargin {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }
        }
        ColumnLayout {
            anchors {
                fill: parent
                margins: 12
            }
            spacing: 12

        Rectangle {
                radius : 12
                width: parent.width
                height: parent.height
                color: "#221b1b16"

        ColumnLayout {
            anchors {
                fill: parent
                margins: 12
            }
            spacing: 12

            RowLayout {
                width: parent.width
            // Header
            Text {
                text: "Notifications"
                color: "#d55c1b"
                font.pixelSize: 24
                font.weight: Font.Bold
                topPadding: 4
            }

            // spacing
            Item { Layout.fillWidth: true }

            // Clear all button
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

            // Notification list
            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 8

                model: NotificationService.trackedNotifications

                delegate: Rectangle {
                    required property var modelData
                    property var notif: modelData

                    width: ListView.view.width
                    height: notifContent.implicitHeight + 20
                    radius: 6
                    color: "#15ffffff"

                    ColumnLayout {
                        id: notifContent
                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                            margins: 12
                        }
                        spacing: 6

                        // Top row: icon + title + dismiss
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            IconImage {
                                Layout.preferredWidth: 20
                                Layout.preferredHeight: 20
                                Layout.maximumWidth: 20
                                Layout.maximumHeight: 20
                                source: Quickshell.iconPath(notif.appIcon ?? "", "")
                                visible: source !== ""
                            }

                            Text {
                                Layout.fillWidth: true
                                text: notif.summary ?? ""
                                color: "#ffffff"
                                font.pixelSize: 12
                                font.weight: Font.Medium
                                elide: Text.ElideRight
                                textFormat: Text.PlainText
                            }

                            Text {
                                text: notif.time
                                    ? Qt.formatDateTime(new Date(notif.time * 1000), "hh:mm")
                                    : ""
                                color: "#555"
                                font.pixelSize: 10
                            }

                            Text {
                                text: "✕"
                                color: "#555"
                                font.pixelSize: 11

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: notif.tracked = false
                                    cursorShape: Qt.PointingHandCursor
                                }
                            }
                        }

                        // Body
                        Text {
                            Layout.fillWidth: true
                            text: notif.body ?? ""
                            color: "#aaaaaa"
                            font.pixelSize: 11
                            wrapMode: Text.WordWrap
                            maximumLineCount: 4
                            elide: Text.ElideRight
                            textFormat: Text.PlainText
                            visible: text !== ""
                        }

                        // Action buttons
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            visible: notif.actions && notif.actions.length > 0

                            Repeater {
                                model: notif.actions ?? []

                                delegate: Rectangle {
                                    required property var modelData
                                    property var action: modelData

                                    height: 24
                                    implicitWidth: actionLabel.implicitWidth + 16
                                    radius: 4
                                    color: "#22d55c1b"

                                    Text {
                                        id: actionLabel
                                        anchors.centerIn: parent
                                        text: action.text ?? ""
                                        color: "#d55c1b"
                                        font.pixelSize: 11
                                    }


                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: action.invoke()
                                        cursorShape: Qt.PointingHandCursor
                                    }
                                }
                            }
                        }
                    }
                }
                }
            }
            }

            // Empty state
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: NotificationService.trackedNotifications.values.length === 0

                Text {
                    anchors.centerIn: parent
                    text: "No notifications"
                    color: "#444"
                    font.pixelSize: 12
                }
            }
        }
    }
}