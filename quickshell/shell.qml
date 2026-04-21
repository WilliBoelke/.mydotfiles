//@ pragma UseQApplication

import Quickshell
import QtQuick
import Quickshell.Hyprland
import qs.bars

ShellRoot {

    // Bar , SideMenu obejct pairing

    Variants {
        model: Quickshell.screens
        delegate: Component {
            QtObject {
                id: root

                required property var modelData

                property bool sideMenuLeftOpen: false
                property bool sideMenuRightOpen: false
                property bool funkeOpen: false



                // --- panels ---


                property var menuLeft: SideMenuLeft
                {
                    open: root.sideMenuLeftOpen
                    screen: modelData
                }

                property var menuRight: SideMenuRight
                {
                    open: root.sideMenuRightOpen
                    screen: modelData
                }

                property var bar: BottomBar
                {
                    screen: modelData
                    sideMenuLeftOpen: root.sideMenuLeftOpen
                    sideMenuRightOpen: root.sideMenuRightOpen

                    onToggleSideLeftMenu: root.sideMenuLeftOpen = !root.sideMenuLeftOpen
                    onToggleSideRightMenu: root.sideMenuRightOpen = !root.sideMenuRightOpen
                    onToggleFunke: root.funkeOpen = !root.funkeOpen
                }
                property var topbar: TopBar
                {
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

