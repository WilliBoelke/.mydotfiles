import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import Quickshell.Io

Row {
    id: quickSettings

    property real currentVolume: 0

    spacing: 12

    Component.onCompleted: {
        if (Pipewire.defaultAudioSink?.audio)
            quickSettings.currentVolume = Pipewire.defaultAudioSink.audio.volume;
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
        label: `${(quickSettings.currentVolume* 100).toFixed(0)}%`

        onClicked: pavucontrolProcess.running = true
    }

    BarButton {
        icon: "\uf294"
        label: "Network1"

        onClicked: console.log("volume clicked")
    }
    BarButton {
        icon: "\uf1eb"
        label: "Connected"

        onClicked: console.log("volume clicked")
    }

    Process {
        id: pavucontrolProcess
        command: ["pavucontrol"]
    }
}

