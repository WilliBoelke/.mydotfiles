import Quickshell
import QtQuick
import Quickshell.Hyprland
import qs.bars

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
                id: root

                property var bar: BottomBar {
                    screen: modelData
                    sideMenuLeftOpen: root.sideMenuLeftOpen
                    sideMenuRightOpen: root.sideMenuRightOpen

                    onToggleSideLeftMenu: root.sideMenuLeftOpen = !root.sideMenuLeftOpen
                    onToggleSideRightMenu: root.sideMenuRightOpen = !root.sideMenuRightOpen
                }
                property var menuLeft: SideMenuLeft {
                    open: root.sideMenuLeftOpen
                    screen: modelData
                }
                property var menuRight: SideMenuRight {
                    open: root.sideMenuRightOpen
                    screen: modelData
                }
                required property var modelData
                property bool sideMenuLeftOpen: false
                property bool sideMenuRightOpen: false
                property var topbar: TopBar {
                    screen: modelData
                    sideMenuLeftOpen: root.sideMenuLeftOpen
                    sideMenuRightOpen: root.sideMenuRightOpen

                    onToggleSideLeftMenu: root.sideMenuLeftOpen = !root.sideMenuLeftOpen
                    onToggleSideRightMenu: root.sideMenuRightOpen = !root.sideMenuRightOpen
                }
            }
        }
    }
}

