// BluetoothDeviceItem.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth
import qs.decoratives
import qs.services

InteractableCard {
    id: item

    property bool cardMode: true

    property BluetoothDevice device

    height: parent.height
    width: parent.width

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    MouseArea {
        id: hoverArea

        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
    }

    // Card layout
    RowLayout {
        anchors.centerIn: parent
        spacing: 12
        visible: item.cardMode


        Text {
            Layout.fillWidth: true
            color: ThemeService.active.accent
            font.family: "Agave Nerd Font Mono"
            font.pixelSize: 28
            horizontalAlignment: Text.AlignHCenter
            text: "\uf293"
        }

        ColumnLayout {
            spacing: 3
            visible: item.cardMode

            Text {
                Layout.fillWidth: true
                color: ThemeService.active.accent
                font.family: "Agave Nerd Font Mono"
                elide: Text.ElideRight
                font.pixelSize: 16
                font.weight: Font.Bold
                horizontalAlignment: Text.AlignHCenter
                text: item.device.name
            }
            Row {
                Layout.alignment: Qt.AlignHCenter
                spacing: 4
                visible: item.device.batteryAvailable

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#aaffffff"
                    font.family: "Agave Nerd Font Mono"
                    font.pixelSize: 10
                    text: "\uf240"
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#aaffffff"
                    font.pixelSize: 10
                    text: Math.round(item.device.battery * 100) + "%"
                }
            }
            Text {
                Layout.fillWidth: true
                color: hoverArea.containsMouse ? ThemeService.active.accent : "#55ffffff"
                font.family: "Agave Nerd Font Mono"
                font.pixelSize: 10
                horizontalAlignment: Text.AlignHCenter
                text: "\uf127  Disconnect"

                Behavior on color {
                    ColorAnimation {
                        duration: 150
                    }
                }
            }
        }
    }

    // List item layout
    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        height: 120
        spacing: 12
        visible: !item.cardMode

        Text {
            color: item.device.connected ? ThemeService.active.accent : ThemeService.active.accent
            font.family: "Agave Nerd Font Mono"
            font.pixelSize: 18
            text: "\uf293"
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                Layout.fillWidth: true
                color: ThemeService.active.accent
                elide: Text.ElideRight
                font.pixelSize: 14
                font.weight: Font.ExtraBold
                font.family: "Agave Nerd Font Mono"
                text: item.device.name
            }
            Text {
                color: item.device.connected ? ThemeService.active.notification : "#88ffffff"
                font.pixelSize: 10
                text: item.device.connected ? "Connected" : (item.device.paired ? "Paired" : "Available")
            }
        }
        Text {
            color: ThemeService.active.notification
            font.family: "Agave Nerd Font Mono"
            font.pixelSize: 16
            text: "\uf240 " + Math.round(item.device.battery * 100) + "%"
            visible: item.device.batteryAvailable
        }

        Rectangle {
            border.color: item.device.connected ? notification : "#44ffffff"
            border.width: notification
            color: item.device.connected ? "#33d55c1b" : "#22ffffff"
            height: 28
            radius: 4
            width: 72

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: item.device.connected = !item.device.connected
            }
            Text {
                anchors.centerIn: parent
                color: item.device.connected ? "#d55c1b" : "#aaffffff"
                font.pixelSize: 10
                text: item.device.connected ? "Disconnect" : "Connect"
            }
        }
    }
}