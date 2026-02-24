import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.services

Item {
    id: root

    implicitWidth: row.implicitWidth + 16
    implicitHeight: parent.height

    property bool sideMenuOpen: false
    signal toggleSideMenu()

    property var lastNotification: {
        var notifs = NotificationService.trackedNotifications.values
        return notifs.length > 0 ? notifs[notifs.length - 1] : null
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.toggleSideMenu()
        cursorShape: Qt.PointingHandCursor
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 24



        Text {
            text: "🔔"
            color: root.sideMenuOpen ? "#d55c1b" : "#ffffff"
            font.pixelSize: 14
            visible: root.lastNotification === null
        }

        ColumnLayout {
            spacing: 0.5

            Text {
                Layout.preferredWidth: 160
                Layout.maximumWidth: 160
                horizontalAlignment: Text.AlignRight
                text: root.lastNotification?.summary ?? ""
                color: "#C35A24"
                font.pixelSize: 14
                font.weight: Font.Medium
                elide: Text.ElideRight
            }

            Text {
                Layout.preferredWidth: 160
                Layout.maximumWidth: 160
                horizontalAlignment: Text.AlignRight
                text: root.lastNotification?.appName ?? ""
                color: "#C35A24"
                font.pixelSize: 12
                elide: Text.ElideRight
            }
        }

        Rectangle {
            width: 28
            height: 28
            radius: 4
            color: "transparent"
            visible: root.lastNotification !== null
            layer.enabled: true

            IconImage {
                anchors.fill: parent
                source: Quickshell.iconPath(root.lastNotification?.appIcon ?? "", "")
                visible: source !== ""
            }

            Text {
                anchors.centerIn: parent
                text: "🔔"
                font.pixelSize: 14
                color: "#d55c1b"
                visible: (root.lastNotification?.appIcon ?? "") === ""
            }
        }

    }
}