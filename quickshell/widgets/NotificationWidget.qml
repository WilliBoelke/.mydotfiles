import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.services

Rectangle {
    id: root

    property color backgroundColor: hoverArea.containsMouse ? "#20ffffff" : "transparent"
    property var lastNotification: {
        var notifs = NotificationService.trackedNotifications.values;
        return notifs.length > 0 ? notifs[notifs.length - 1] : null;
    }
    property bool sideMenuOpen: false

    signal toggleSideMenu

    color: backgroundColor
    implicitHeight: parent.height
    implicitWidth: row.implicitWidth + 16
    radius: 4

    MouseArea {
        id: hoverArea

        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: root.toggleSideMenu()
    }
    RowLayout {
        id: row

        anchors.centerIn: parent
        spacing: 24

        ColumnLayout {
            spacing: 0.5

            Text {
                Layout.maximumWidth: 160
                Layout.preferredWidth: 160
                color: "#C35A24"
                elide: Text.ElideRight
                font.pixelSize: 14
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignRight
                text: root.lastNotification?.summary ?? ""
            }
            Text {
                Layout.maximumWidth: 160
                Layout.preferredWidth: 160
                color: "#C35A24"
                elide: Text.ElideRight
                font.pixelSize: 12
                horizontalAlignment: Text.AlignRight
                text: root.lastNotification?.appName ?? ""
            }
        }
        Rectangle {
            color: "transparent"
            height: 28
            layer.enabled: true
            radius: 4
            visible: root.lastNotification !== null
            width: 28

            Text {
                anchors.centerIn: parent
                color: "#d55c1b"
                font.pixelSize: 14
                text: "󰎟"
                visible: (root.lastNotification?.appIcon ?? "") === ""
            }
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: "#d55c1b"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 14
            font.weight: Font.Bold
            text: "󰎟"
        }
    }
}