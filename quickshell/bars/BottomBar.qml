import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Hyprland
import qs.widgets
import qs.services

PanelWindow {
    id: root

    property bool sideMenuLeftOpen: false

    // Flyout open state lives here so bar and flyout share it
    property bool sideMenuRightOpen: false

    signal toggleSideLeftMenu
    signal toggleSideRightMenu

    color: "transparent"
    implicitHeight: 44

    anchors {
        bottom: true
        left: true
        right: true
    }

    Rectangle {
        anchors.fill: parent
        color: ThemeService.active.bgBase


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
            SystemStatusWidget {
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