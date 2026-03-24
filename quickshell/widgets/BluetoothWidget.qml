import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Io
import Quickshell.Bluetooth
import QtQuick.Controls
import qs.decoratives

Rectangle {
    id: root

    property string btAddress: Bluetooth.defaultAdapter.address
    property bool btConnected: Bluetooth.defaultAdapter.connected
    property string btName: Bluetooth.defaultAdapter.name
    property var connectedDevices: Bluetooth.defaultAdapter.devices.values.filter(d => d.connected)
    property bool expanded: false

    color: "transparent"
    implicitHeight: expanded ? 120 + 300 : 120
    implicitWidth: 200

    // transition height
    Behavior on implicitHeight {
        NumberAnimation {
            duration: 200
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        // the menu
        RowLayout {
            Layout.fillWidth: true
            Layout.maximumHeight: 120
            Layout.preferredHeight: 120
            spacing: 12

            Repeater {
                model: root.connectedDevices

                delegate: BluetoothDeviceItem {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    cardMode: true
                    device: modelData
                }
            }
            InteractableCard {
                Layout.fillHeight: true
                Layout.preferredWidth: 120

                // clicked on the expand button
                MouseArea {
                    id: hoverArea

                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onClicked: {
                        root.expanded = !root.expanded;
                        if (root.expanded) {
                            Bluetooth.defaultAdapter.discovering = true;
                        } else {
                            Bluetooth.defaultAdapter.discovering = false;
                        }
                    }
                }

                // Nerdmont settings icon
                Text {
                    anchors.centerIn: parent
                    color: "#d55c1b"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 46
                    horizontalAlignment: Text.AlignHCenter
                    text: "󰂳"
                }
            }
        }

        // expanded layout for further settings
        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 8
            visible: root.expanded

            RowLayout {
                Layout.fillWidth: true
                Layout.maximumHeight: 30
                Layout.preferredHeight: 30
                spacing: 8

                // A SETTINGS ROW?
            }
            Flickable {
                Layout.fillHeight: true
                Layout.fillWidth: true
                clip: true
                contentHeight: deviceList.implicitHeightd
                contentWidth: width

                ColumnLayout {
                    id: deviceList

                    spacing: 8
                    width: parent.width

                    // List discovered devices
                    Repeater {
                        model: Bluetooth.defaultAdapter.devices.values

                        delegate: BluetoothDeviceItem {
                            Layout.fillWidth: true
                            cardMode: false
                            device: modelData
                            implicitHeight: 52
                        }
                    }
                }
            }
        }
    }
}
