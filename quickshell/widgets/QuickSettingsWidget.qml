import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import Quickshell.Io
import Quickshell.Bluetooth

Row {
    id: quickSettings

    property bool btConnected: Bluetooth.defaultAdapter.connected
    property bool btConnectedToo: Bluetooth.defaultAdapter.devices.values.filter(d => d.connected)[0] !== undefined
    property bool btEnabled: Bluetooth.defaultAdapter.enabled
    property real currentVolume: 0

    spacing: 12

    Component.onCompleted: {
        if (Pipewire.defaultAudioSink?.audio)
            quickSettings.currentVolume = Pipewire.defaultAudioSink.audio.volume;
        const adapter = Bluetooth.defaultAdapter;
        for (const d of adapter?.devices.values) {
            console.log("device:", d.name, "connected:", d.connected);
        }
    }

    PwObjectTracker {
        id: tracker
        objects: Pipewire.defaultAudioSink ? [Pipewire.defaultAudioSink] : []
    }
    Connections {
        function onVolumesChanged() {
            quickSettings.currentVolume = Pipewire.defaultAudioSink.audio.volume;
        }


        target: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio : null
    }
    BarButton {
        icon: "\uf028"
        label: `${(quickSettings.currentVolume * 100).toFixed(0)}%`

        onClicked: pavucontrolProcess.running = true
    }
    BarButton {
        icon: "\uf294"
        label: btConnectedToo ? Bluetooth.defaultAdapter.devices.values.filter(d => d.connected)[0].name : "not connected"

        onClicked: console.log("volume clicked")
    }
    BarButton {
        icon: "\uf1eb"
        label: "network"

        onClicked: console.log("volume clicked")
    }
    Process {
        id: pavucontrolProcess

        command: ["pavucontrol"]
    }
}

