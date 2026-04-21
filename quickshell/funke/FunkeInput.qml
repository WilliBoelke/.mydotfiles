import QtQuick
import QtQuick.Controls
import qs.services
import Quickshell.Hyprland

Rectangle {
    id: root

    property alias text: input.text
    signal submitted(string text)

    width: 200
    height: 32
    radius: 12

    // Glassmorphism background
    color: ThemeService.active.bgCard
    border.color: ThemeService.active.accent
    border.width: 1

    // Subtle glow
    layer.enabled: true
    layer.effect: null

    Row {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        spacing: 12

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: ""  // nerd font search icon
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 16
            color: ThemeService.active.accent
        }

        TextInput {
            id: input
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - 40
            color: "#ffffff"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 15
            selectionColor: Qt.rgba(213, 92, 27, 0.4)
            selectedTextColor: "#ffffff"

            Keys.onReturnPressed: root.submitted(text)
        }
    }

    // Focus glow animation
    Behavior on border.color {
        ColorAnimation { duration: 200 }
    }

    Behavior on width {
        NumberAnimation { duration: 200 }
    }

    states: State {
        name: "focused"
        when: input.activeFocus
        PropertyChanges {
            target: root
            border.color: ThemeService.active.accentBright
            width: 600
            color: Qt.rgba(213, 92, 27, 0.08)
        }
    }




    // --- Keyboard shortcuts ---
    GlobalShortcut {
            appid: "quickshell"
            name: "toggleFunke"

             onPressed: {
                if (root.screen.name === Hyprland.focusedMonitor?.name) {

                }
            }
        }


}