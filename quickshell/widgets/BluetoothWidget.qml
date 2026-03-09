import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Io
import Quickshell.Bluetooth
import Quickshell

Rectangle {
    id: root

    property string btAddress: Bluetooth.defaultAdapter.address
    property bool btConnected: Bluetooth.defaultAdapter.connected
    property string btName: Bluetooth.defaultAdapter.name
    property var connectedDevices: Bluetooth.defaultAdapter.devices.values.filter(d => d.connected)

    color: "transparent"
    implicitHeight: 120
    implicitWidth: 200

    // the menu
    RowLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        height: 120
        spacing: 8

        Repeater {
            model: root.connectedDevices

            delegate: BluetoothDeviceItem {
                Layout.fillWidth: true
                Layout.fillHeight: true
                cardMode: true
                device: modelData
            }
        }
    }
}
