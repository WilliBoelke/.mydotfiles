import Quickshell
import QtQuick
import Quickshell.Hyprland

ShellRoot {



    Variants {
        model: Quickshell.screens
        delegate: Component {
            NotificationToast {
                required property var modelData
                screen: modelData
            }
        }
    }

    // Bar , SideMenu obejct pairing

    Variants {
        model: Quickshell.screens
        delegate: Component {
            QtObject {
                id : root
                required property var modelData
                property bool sideMenuOpen: false

                property var bar: Bar {
                    screen: modelData
                    sideMenuOpen: root.sideMenuOpen
                    onToggleSideMenu: root.sideMenuOpen = !root.sideMenuOpen
                }

                property var menu: SideMenu {
                    screen: modelData
                    open: root.sideMenuOpen
                }
            }
        }
    }




}