import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Hyprland

PanelWindow {
    id: root
    color: "#1a000000"
    anchors { bottom: true; left: true; right: true }
    implicitHeight: 40

    // Flyout open state lives here so bar and flyout share it
    property bool flyoutOpen: false
    property bool sideMenuOpen: false
    signal toggleSideMenu()

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 0

        // Left: music widget
        MusicWidget {
            flyoutOpen: root.flyoutOpen
            onToggleFlyout: root.flyoutOpen = !root.flyoutOpen
        }

        Item { Layout.fillWidth: true }

        // Right: placeholder for notifications later
        Text {
            text: "🔔"
            color: "#888"
            rightPadding: 8

            MouseArea {
                anchors.fill: parent
                onClicked: root.toggleSideMenu()
                cursorShape: Qt.PointingHandCursor
            }
        }


        GlobalShortcut {
            appid: "quickshell"
            name: "toggleSideMenu"
            onPressed: {
                if (root.screen.name === Hyprland.focusedMonitor?.name) {
                    root.toggleSideMenu()
                }
            }
        }
    }



    // Flyout popup, anchored to this bar's screen
    MusicFlyout {
        id: flyout
        visible: root.flyoutOpen
        parentBar: root
    }
}