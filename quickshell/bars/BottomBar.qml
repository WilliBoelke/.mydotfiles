import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.widgets
import qs.services
import qs.funke

PanelWindow {
    id: root

    // --- Properties ---
    property bool sideMenuLeftOpen: false
    property bool sideMenuRightOpen: false
    // --- Signals ---
    signal toggleSideLeftMenu
    signal toggleSideRightMenu
    signal toggleFunke
    // --- Window config ---
    color: "transparent"
    implicitHeight: 44
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors {
        bottom: true
        left: true
        right: true
    }

    // --- Global shortcuts ---
    GlobalShortcut {
        appid: "quickshell"
        name: "toggleSideLeftMenu"
        onPressed: {
            if (root.screen.name === Hyprland.focusedMonitor?.name)
                root.toggleSideLeftMenu()
        }
    }

    GlobalShortcut {
        appid: "quickshell"
        name: "toggleSideRightMenu"
        onPressed: {
            if (root.screen.name === Hyprland.focusedMonitor?.name)
                root.toggleSideRightMenu()
        }
    }

    // --- Content ---
    Rectangle {
        anchors.fill: parent
        color: ThemeService.active.bgBase

        RowLayout {
            anchors.fill: parent
            spacing: 0

            MusicWidget {
                sideMenuOpen: root.sideMenuRightOpen
                onToggleSideMenu: root.toggleSideLeftMenu()
            }

            Item { Layout.fillWidth: true }

            FunkeInput {
                anchors.centerIn: parent
            }

            Item { Layout.fillWidth: true }

            SystemStatusWidget {
                sideMenuOpen: root.sideMenuLeftOpen
                onToggleSideMenu: root.toggleSideRightMenu()
            }
        }
    }
}