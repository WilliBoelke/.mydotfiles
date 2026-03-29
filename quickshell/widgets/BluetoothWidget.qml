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

    header: RowLayout {
        Layout.fillWidth: true
        Layout.maximumHeight: 120
        Layout.preferredHeight: 120
        spacing: 12

        Repeater {
            model: bluetoothWidget.connectedDevices

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
                size: 46
            }
        }
    }
}
