// BluetoothDeviceItem.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth

Rectangle {
    id: item

    property bool cardMode: true  // true = card, false = list item

    property BluetoothDevice device

    border.color: device.connected ? "#33d55c1b" : "#22ffffff"
    border.width: 1
    color: hoverArea.containsMouse ? "#20ffffff" : "#15ffffff"
    implicitHeight: cardMode ? 120 : 52
    implicitWidth: cardMode ? 140 : 280
    height: cardMode ? 120 : 52
    radius: 8

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
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 6
        visible: item.cardMode
        width: parent.width - 16

        Text {
            Layout.fillWidth: true
            color: "#d55c1b"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 22
            horizontalAlignment: Text.AlignHCenter
            text: "\uf293"
        }
        Text {
            Layout.fillWidth: true
            color: "#ffffff"
            elide: Text.ElideRight
            font.pixelSize: 12
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
                font.family: "JetBrainsMono Nerd Font"
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
            color: hoverArea.containsMouse ? "#d55c1b" : "#55ffffff"
            font.family: "JetBrainsMono Nerd Font"
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

    // List item layout
    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        height: 120
        spacing: 12
        visible: !item.cardMode

        Text {
            color: item.device.connected ? "#d55c1b" : "#88ffffff"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 18
            text: "\uf293"
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                Layout.fillWidth: true
                color: "#ffffff"
                elide: Text.ElideRight
                font.pixelSize: 12
                font.weight: Font.Bold
                text: item.device.name
            }
            Text {
                color: item.device.connected ? "#d55c1b" : "#88ffffff"
                font.pixelSize: 10
                text: item.device.connected ? "Connected" : (item.device.paired ? "Paired" : "Available")
            }
        }
        Text {
            color: "#aaffffff"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 10
            text: "\uf240 " + Math.round(item.device.battery * 100) + "%"
            visible: item.device.batteryAvailable
        }
        Rectangle {
            border.color: item.device.connected ? "#d55c1b" : "#44ffffff"
            border.width: 1
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