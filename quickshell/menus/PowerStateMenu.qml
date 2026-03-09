import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import qs.consts

Drawer {
    direction: "right"
    // Shutdown
    Text {
        color: Colors.red
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 20
        text: "\uf011"
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                procShutdown.running = true;
            }
        }
    }
    // Reboot
    Text {
        color: Colors.green
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 20
        text: "\uf012"
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                procReboot.running = true;
            }
        }
    }
    // Logout
    Text {
        color: Colors.yellow
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 20
        text: "\uf08b"
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                procLogout.running = true;
            }
        }
    }


    Process {
        id: procShutdown
        command: ["systemctl", "poweroff"]
    }
    Process {
        id: procReboot
        command: ["systemctl", "reboot"]
    }
    Process {
        id: procLogout
        command: ["sh", "-c", "pidof hyprlock || hyprlock"]
    }
}