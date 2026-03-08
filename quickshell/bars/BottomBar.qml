import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Hyprland
import qs.widgets
PanelWindow {
    id: root

    property bool sideMenuLeftOpen: false

    // Flyout open state lives here so bar and flyout share it
    property bool sideMenuRightOpen: false

    signal toggleSideLeftMenu
    signal toggleSideRightMenu

    color: "transparent"
    implicitHeight: 40

    anchors {
        bottom: true
        left: true
        right: true
    }
    margins {
        bottom: 12
        left: 20
        right: 20
        top: 0
    }
    Rectangle {
        anchors.fill: parent
        color: "#15000000"
        radius: 12

        RowLayout {
            anchors.fill: parent
            height: parent.height
            spacing: 0

            // Left: music widget
            MusicWidget {
                sideMenuOpen: root.sideMenuRightOpen

                onToggleSideMenu: root.toggleSideLeftMenu()
            }
            Item {
                Layout.fillWidth: true
            }

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
                        root.toggleSideLeftMenu();
                    }
                }
            }
            GlobalShortcut {
                appid: "quickshell"
                name: "toggleSideRightMenu"

                onPressed: {
                    if (root.screen.name === Hyprland.focusedMonitor?.name) {
                        root.toggleSideRightMenu();
                    }
                }
            }
        }
    }
}