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
                property bool sideMenuRightOpen: false
                property bool sideMenuLeftOpen: false

                property var bar: Bar {
                    screen: modelData
                    sideMenuRightOpen: root.sideMenuRightOpen
                    sideMenuLeftOpen: root.sideMenuLeftOpen
                    onToggleSideRightMenu: root.sideMenuRightOpen = !root.sideMenuRightOpen
                    onToggleSideLeftMenu: root.sideMenuLeftOpen = !root.sideMenuLeftOpen
                }

                property var menuLeft: SideMenuLeft {
                    screen: modelData
                    open: root.sideMenuLeftOpen
                }

                property var menuRight: SideMenuRight {
                    screen: modelData
                    open: root.sideMenuRightOpen
                }
            }
        }
    }




}