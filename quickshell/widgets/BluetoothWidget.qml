import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Io
import Quickshell.Bluetooth
import QtQuick.Controls
import qs.decoratives

CollapsibleCard {
    id: bluetoothWidget

    property string btAddress: Bluetooth.defaultAdapter.address
    property bool btConnected: Bluetooth.defaultAdapter.connected
    property string btName: Bluetooth.defaultAdapter.name
    property var connectedDevices: Bluetooth.defaultAdapter.devices.values.filter(d => d.connected)

    body: ColumnLayout {
        Layout.fillHeight: true
        Layout.fillWidth: true
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            Layout.maximumHeight: 30
            Layout.preferredHeight: 30
            spacing: 8

            // A SETTINGS ROW?
        }

        ColumnLayout {
            id: deviceList

            Layout.fillWidth: true
            spacing: 8

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


    header: Item {
        width: parent.width
        implicitHeight: 64

        RowLayout {
            anchors.fill: parent
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 8

                Repeater {
                    model: bluetoothWidget.connectedDevices

                    delegate: BluetoothDeviceItem {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        cardMode: true
                        device: modelData
                    }
                }
            }

            InteractableCard {
                Layout.fillHeight: true
                Layout.preferredWidth: 64

                // clicked on the expand button
                MouseArea {
                    id: hoverArea

                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onClicked: {
                        bluetoothWidget.toggle();
                        if (bluetoothWidget.expanded) {
                            Bluetooth.defaultAdapter.discovering = true;
                        } else {
                            Bluetooth.defaultAdapter.discovering = false;
                        }
                    }
                }
                Icon {
                    icon: "󰂳"
                    size: 22
                }
            }
        }
    }
}
