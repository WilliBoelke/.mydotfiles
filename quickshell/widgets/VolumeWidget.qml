import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import Quickshell.Io
import qs.controls
import qs.services

Rectangle {
    color: "transparent"
    height: 18
    radius: 8
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