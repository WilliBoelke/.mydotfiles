import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import qs.services

Drawer {
    direction: "right"

    // Shutdown
    Text {
        color: ThemeService.active.accent
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
        color: ThemeService.active.accent
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 20
        text: "\udb81\udf09"

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
        color: ThemeService.active.accent
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

        command: ["sh", "-c", "~/.config/hypr/scripts/power.sh shutdown"]
    }
    Process {
        id: procReboot

        command: ["sh", "-c", "~/.config/hypr/scripts/power.sh reboot"]
    }
    Process {
        id: procLogout

        command: ["sh", "-c", "~/.config/hypr/scripts/power.sh lock"]
    }
    Process {
        id: procHibernate

        command: ["sh", "-c", "~/.config/hypr/scripts/power.sh hibernate"]
    }
}
