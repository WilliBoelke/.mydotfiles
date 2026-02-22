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
    property bool sideMenuRightOpen: false
    property bool sideMenuLeftOpen: false
    signal toggleSideLeftMenu()
    signal toggleSideRightMenu()



    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 0

        // Left: music widget
        MusicWidget {
            sideMenuOpen: root.sideMenuRightOpen
            onToggleSideMenu: root.toggleSideLeftMenu()
        }


        Item { Layout.fillWidth: true }

        // Right: placeholder for notifications later
        NotificationWidget {
            sideMenuOpen: root.sideMenuLeftOpen
            onToggleSideMenu: root.toggleSideRightMenu()
        }


        GlobalShortcut {
            appid: "quickshell"
            name: "toggleSideLeftMenu"
            onPressed: {
                if (root.screen.name === Hyprland.focusedMonitor?.name) {
                    root.toggleSideLeftMenu()
                }
            }
        }


        GlobalShortcut {
            appid: "quickshell"
            name: "toggleSideRightMenu"
            onPressed: {
                if (root.screen.name === Hyprland.focusedMonitor?.name) {
                    root.toggleSideRightMenu()
                }
            }
        }
    }
}