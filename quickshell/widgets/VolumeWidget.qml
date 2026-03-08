import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import Quickshell.Io
import QtQuick.Controls

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
    Slider {
        anchors.fill: parent
        value: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio.volume : 0

        background: Rectangle {
            color: "transparent"  // dim track

            height: 46
            radius: 6
            width: parent.availableWidth

            Rectangle {
                color: "#d55c1b"  // orange fill
                height: parent.height
                radius: 6
                width: parent.parent.visualPosition * parent.width
            }
        }
        handle: Rectangle {
            height: 0
            radius: 0
            visible: false
            width: 0
        }

        onValueChanged: Pipewire.defaultAudioSink.audio.volume = value
    }
}