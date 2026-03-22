import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import Quickshell.Io
import qs.controls

Rectangle {
    property color backgroundColor: hoverArea.containsMouse ? "#20ffffff" : "#15ffffff"

    color: backgroundColor
    height: 46
    radius: 6
    width: parent.width

    PwObjectTracker {
        id: tracker
        objects: Pipewire.defaultAudioSink ? [Pipewire.defaultAudioSink] : []
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
    }

    EmberSlider {
              anchors.fill: parent
        value: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio.volume : 0
    }
}